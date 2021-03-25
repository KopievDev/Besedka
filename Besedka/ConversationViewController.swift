//
//  ConversationViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 02.03.2021.
//

import UIKit

class ConversationViewController: UIViewController {
    // MARK: - Propetries
    var channel: Channel? {
        didSet {configure()}
    }
    let firebase = FirebaseService()
    var messages = [Message]()
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
        getMyName()
        createdDesign()
        listenMessages()
        registerForKeyboardNotification()
    }
    
    override var canBecomeFirstResponder: Bool {
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
        guard let channel = channel else {return}
        title = channel.name
        
    }
    
    private func getMyName() {
        let fileOpener = FileManagerGCD()
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
                                        height: self.view.frame.height - customInputView.frame.height - 5)
        customInputView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        messageTableView.keyboardDismissMode = .interactive
    }
    
    fileprivate func listenMessages() {
        guard let channelId = channel?.identifier else {return}
        firebase.addSortedMessageListener(from: channelId) {[weak self] (message) in
            guard let self = self else {return}
            self.messages = message
            self.messageTableView.reloadData()
            self.messageTableView.scrollToLastRow(animated: false)
        }
    }
    // MARK: - Selectors
    
    @objc private func sendMessage() {
        guard let content = self.customInputView.messageInputTextView.text,
              content.filter({ $0 != " " }).count > 0 else {
            print("empty")
            return
        }
        guard let channelId = channel?.identifier else {return}
        firebase.addNew(message: Message(content: content, name: self.myName), to: channelId)
        self.customInputView.messageInputTextView.text = ""
        self.messageTableView.scrollToLastRow(animated: false)

    }
    
}

// MARK: - Extensions ConversationViewController TableViewDataSource
extension ConversationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageCell else {return UITableViewCell()}
        cell.widthMessage = self.view.bounds.width * 0.75 - 12
        cell.leftBubble.isActive = false
        cell.rightBubble.isActive = false
        cell.textViewTopFromMe.isActive = false
        cell.configureCell(message: self.messages[indexPath.row])
        
        return cell
    }

}
// MARK: - Extensions ConversationViewController TableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}

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
        
        if view.bounds.origin.y == 0 && keyboardFrame.height > 100 && content > placeBeforeKeyboard {
            if content > (view.frame.height - 100) {
                self.view.bounds.origin.y += keyboardFrame.height - 50
            } else {
                self.view.bounds.origin.y += content - placeBeforeKeyboard
            }
        }
    }

    @objc private func keyboardWillHide() {
        if view.bounds.origin.y != 0 {
            self.view.bounds.origin.y = 0
        }
    }

}
