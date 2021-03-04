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
    private lazy var userTableView : UITableView = {
        let table = UITableView(frame: view.frame, style: .plain)
        table.register(MessageCell.self, forCellReuseIdentifier: cellId)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.estimatedRowHeight = 100
       // table.transform = CGAffineTransform(scaleX: 1, y: -1)
        table.remembersLastFocusedIndexPath = true
        return table
    }()
   
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        userTableView.scrollToLastRow(animated: true)

    }
    
    //MARK: - Helpers
    func configure(){
        guard let user = user else {return}
        view.addSubview(userTableView)
        configureNavigationBar(withTitle: user.name, image: UIImage(named: user.image ?? "Anonymous") ?? UIImage())

    }
}

//MARK: - Extensions TableView
extension ConversationViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.messages?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageCell{
            cell.widthMessage = self.view.bounds.width * 0.75 - 12
            cell.leftBubble.isActive = false
            cell.rightBubble.isActive = false
            //cell.transform = CGAffineTransform(scaleX: 1, y: -1)

            cell.message = user?.messages?[indexPath.row]
            
            return cell
        }
        return UITableViewCell()
    }

}
extension ConversationViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }

}

extension UITableView {
    func setOffsetToBottom(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: true)
    }

    func scrollToLastRow(animated: Bool) {
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0) as IndexPath, at: .none, animated: animated)
            print(numberOfRows(inSection: 0))
        }
    }
    
}


