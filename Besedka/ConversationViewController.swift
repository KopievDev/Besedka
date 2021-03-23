//
//  ConversationViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 02.03.2021.
//

import UIKit

class ConversationViewController: UIViewController {
    //MARK: - Propetries
    var user : User? {
        didSet{configure()}
    }
    private let cellId = "cellMessage"
    private lazy var messageTableView : UITableView = {
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
   
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(messageTableView)
        navigationItem.largeTitleDisplayMode = .never
        messageTableView.scrollToLastRow(animated: false)

    }
    deinit {
        print("deinit MessageView")
    }

    
    //MARK: - Helpers
    func configure(){
        guard let user = user else {return}
        configureNavigationBar(withTitle: user.name ?? "Неизвестный", image: UIImage(named: user.image ?? "Anonymous") ?? UIImage())

    }
}

//MARK: - Extensions ConversationViewController TableViewDataSource
extension ConversationViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageCell else {return UITableViewCell()}
        cell.widthMessage = self.view.bounds.width * 0.75 - 12
        cell.leftBubble.isActive = false
        cell.rightBubble.isActive = false
        //cell.transform = CGAffineTransform(scaleX: 1, y: -1) //Переворот ячейки
        cell.configureCell(message: user?.messages?[indexPath.row])
        
        return cell
    }
    
}
//MARK: - Extensions ConversationViewController TableViewDelegate

extension ConversationViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }

}
