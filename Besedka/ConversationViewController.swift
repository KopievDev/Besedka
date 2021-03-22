//
//  ConversationViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 02.03.2021.
//

import UIKit

class ConversationViewController: UIViewController {
    // MARK: - Propetries
    var user: User? {
        didSet {configure()}
    }
    var channel: Channel? {
        didSet {configure()}
    }
    let firebase = FirebaseService()
    var messages = [Message]()
    
    private let cellId = "cellMessage"
    private lazy var messageTableView: UITableView = {
        let table = UITableView(frame: view.frame, style: .plain)
        table.register(MessageCell.self, forCellReuseIdentifier: cellId)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.estimatedRowHeight = 100
       // table.transform = CGAffineTransform(scaleX: 1, y: -1) // Переворот таблицы
        table.remembersLastFocusedIndexPath = true
        table.backgroundColor = Theme.current.backgroundColor
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(messageTableView)
        navigationItem.largeTitleDisplayMode = .never
        listenMessages()
        
    }
    deinit {
        print("deinit MessageView")
    }
    
    // MARK: - Helpers
    func configure() {
        guard let channel = channel else {return}
        title = channel.name
    }
    
    func listenMessages() {
        guard let channelId = channel?.identifier else {return}
        firebase.addSortedMessageListener(from: channelId) {[weak self] (message) in
            guard let self = self else {return}
            self.messages = message
            self.messageTableView.reloadData()
            self.messageTableView.scrollToLastRow(animated: false)

        }
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
