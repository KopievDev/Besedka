//
//  ConversationViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 02.03.2021.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
    // MARK: - Propetries
    let serviceAssembly = ServiceAssembly()
    var firebase: FireBaseServiceProtocol {
        return serviceAssembly.firebase
    }
    var coreDataService: CoreDataProtocol?
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<MessageDB>()

    var channelDB: ChannelDB? {
        didSet {
            self.channelID = channelDB?.identifier ?? ""
        }
    }
    var messages: [Message] = []
    var channelID: String = ""
    
    var myName: String = ""
        
    private let cellId = "cellMessage"
    private lazy var messageTableView: UITableView = {
        let table = UITableView(frame: view.frame, style: .plain)
        table.register(MessageCell.self, forCellReuseIdentifier: cellId)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.estimatedRowHeight = 100
        table.remembersLastFocusedIndexPath = true
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

        table.backgroundColor = Theme.current.backgroundColor
        return table
    }()
    
    private lazy var  customInputView: CustomInputAccesoryView = {
        let iv = CustomInputAccesoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50 ))
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getMyName()
        createdDesign()
        listenMessages()
        registerForKeyboardNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageTableView.reloadData()
        self.messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageTableView.scrollToLastRow(animated: true)

    }
    override var canBecomeFirstResponder: Bool {
           return true
       }
    override var canResignFirstResponder: Bool {
            return true
    }
    
    override var inputAccessoryView: UIView? {
        return customInputView
    }
    
    deinit {
        print("deinit MessageView")
    }
    
    // MARK: - Helpers
    func configure() {
        guard let channel = channelDB else {return}
        title = channel.name
        
    }
    
    private func getMyName() {
        let fileOpener = serviceAssembly.fileManager
        fileOpener.getUser {[weak self] (user) in
            guard let self = self else {return}
            guard let name = user?.name else {return}
            self.myName = name
        }
    }
    
    fileprivate func createdDesign() {
        view.backgroundColor = Theme.current.backgroundColor
        view.addSubview(messageTableView)
        navigationItem.largeTitleDisplayMode = .never
        customInputView.messageInputTextView.delegate = self
        messageTableView.frame = CGRect(x: 0, y: 0,
                                        width: self.view.frame.width,
                                        height: self.view.frame.height - customInputView.frame.height)
        customInputView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        messageTableView.keyboardDismissMode = .interactive
    }
    
    fileprivate func listenMessages() {
        firebase.addListnerMessegesFrom(channel: channelID) { (messages) in
            self.coreDataService?.save(messages: messages, from: self.channelID )
            let messss = messages.compactMap { (mes) -> Message? in
                return Message(mes)
            }
            messss.forEach { (mes) in
                print(mes.content)
            }
            self.messages = messss
            self.messageTableView.reloadData()
            self.messageTableView.scrollToLastRow(animated: true)
        }
    }
    
    private func edit(message: Message) {

        let alert = UIAlertController(title: nil, message: "\(message.senderName)\n \(message.created.toString())", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = message.content
        }
        let applyButton = UIAlertAction(title: "Изменить", style: .default) {[weak self] (_) in
            guard let content = alert.textFields?.first?.text else {return}
            guard let self = self else { return }
            guard let channelId = self.channelDB?.identifier else {return}
            if content != "" {
                self.firebase.change(message, text: content, in: channelId)
            }
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(applyButton)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    // MARK: - Selectors
    
    @objc private func sendMessage() {
        guard let content = self.customInputView.messageInputTextView.text,
              content.filter({ $0 != " " && $0 != "\n"}).count > 0 else {
            print("empty")
            return
        }
//        guard let channelId = channelDB?.identifier else {return}
        firebase.addNew(message: Message(content: content, name: self.myName), to: channelID)
        self.customInputView.messageInputTextView.text = ""
        self.customInputView.heightText.constant = customInputView.textViewContentSize().height

    }
    
}

// MARK: - Extensions ConversationViewController TableViewDataSource
extension ConversationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageCell else {return UITableViewCell()}

        cell.widthMessage = self.view.bounds.width * 0.75 - 12
        cell.leftBubble.isActive = false
        cell.rightBubble.isActive = false
        cell.textViewTopFromMe.isActive = false
        cell.configureCell(message: messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
// MARK: - Extensions ConversationViewController TableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteChannel = UITableViewRowAction(style: .default, title: "delete") { _, _  in
            guard let channelId = self.channelDB?.identifier else {return}
            if self.messages[indexPath.row].senderId == myId {
                self.firebase.delete(self.messages[indexPath.row], in: channelId)
            }
        }

        let renameChannel = UITableViewRowAction(style: .default, title: "edit") { _, _ in

            if self.messages[indexPath.row].senderId == myId {
                self.edit(message: self.messages[indexPath.row])
            }
        }

        deleteChannel.backgroundColor = .systemRed
        renameChannel.backgroundColor = .systemPurple

        return [deleteChannel, renameChannel]
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customInputView.messageInputTextView.resignFirstResponder()
    }
}

// MARK: - Extension TextView
extension ConversationViewController: UITextViewDelegate {
        
    func textViewDidChange(_ textView: UITextView) {
        UIView.animate(withDuration: 0.1) {
            self.messageTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - self.customInputView.frame.height)
            self.messageTableView.scrollToLastRow(animated: true)
            self.customInputView.placeholderLabel.isHidden = !self.customInputView.messageInputTextView.isEmpty()
        }

        if customInputView.textViewContentSize().height >= 100 {
            customInputView.messageInputTextView.isScrollEnabled = true
            customInputView.heightText.isActive = true
        } else {
            
            customInputView.messageInputTextView.isScrollEnabled = false
            customInputView.heightText.constant = customInputView.textViewContentSize().height

        }
    }
        
    //  Обработка появления клавиатуры
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        let content = messageTableView.contentSize.height
        let placeBeforeKeyboard = view.frame.height - keyboardFrame.height - customInputView.frame.height
        
        if keyboardFrame.height > 100 && content > placeBeforeKeyboard {
            self.messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - 50, right: 0)
            self.messageTableView.scrollToLastRow(animated: true)
        }
    }

    @objc private func keyboardWillHide() {
        self.messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}
