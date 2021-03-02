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
        table.separatorStyle = .none
        return table
    }()
   
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false

    }
    
    
    
    //MARK: - Helpers
    func configure(){
        navigationController?.navigationBar.prefersLargeTitles = false

        guard let user = user else {return}
        self.title = user.name
        view.addSubview(userTableView)
        

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
           
            cell.message = user?.messages?[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }

}
