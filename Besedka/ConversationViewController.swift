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
        iv.messageInputTextView.becomeFirstResponder()
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyName()
        createdDesign()
        listenMessages()
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
    }
    
    fileprivate func listenMessages() {
        guard let channelId = channel?.identifier else {return}
        firebase.addSortedMessageListener(from: channelId) {[weak self] (message) in
            guard let self = self else {return}
            self.messages = message
            self.messageTableView.reloadData()
            self.messageTableView.scrollToLastRow(animated: false)
            
            message.forEach { (mes) in
                print(mes.senderName, " ", mes.content)
            }
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
        print(self.myName)
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
    }
}
