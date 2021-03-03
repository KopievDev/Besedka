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
        

        return table
    }()
   
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
      

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)

    }
    
    //MARK: - Helpers
    func configure(){
        guard let user = user else {return}
        view.addSubview(userTableView)
        configureNavigationBar(withTitle: user.name, image: UIImage(named: user.image ?? "Anonymous") ?? UIImage())
        



    }
    //MARK: - Selectors
    

}

//MARK: - Extensions TableView
extension ConversationViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return user?.messages?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageCell{
            cell.leftBuuble.isActive = false
            cell.rightBubble.isActive = false
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
