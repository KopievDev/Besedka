//
//  ConversationsListViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 28.02.2021.
//

import UIKit

class ConversationsListViewController: UIViewController {

    // MARK: - Properties
    private let cellId = "cell"
    private lazy var userTableView : UITableView = {
        let table = UITableView(frame: view.frame, style: .plain)
        table.register(UserCell.self, forCellReuseIdentifier: cellId)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    var users = [User]()
    var historyArray = [User]()
    var onlineArray = [User]()
    var avatarImage = UIImage()
        
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        createUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userTableView.reloadData()
        updImageProfile()

    }
    //MARK: - Selectors
    @objc func showProfile(){
        print("push")
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sb.instantiateViewController(withIdentifier: "profile")
        guard  let secondViewController = (sb.instantiateViewController(withIdentifier: "profile"))  as? ProfileViewController else {return}
        secondViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(secondViewController, animated: true, completion: nil)

    }
    //MARK: - Helpers
    
    fileprivate func updImageProfile() {
        let defaults = UserDefaults.standard
        if let image = defaults.data(forKey: "saveImg"){
            self.avatarImage = UIImage(data: image, scale: 0.2) ?? UIImage()
        } else {
            self.avatarImage = UIImage(named: "Anonymous") ?? UIImage()
        }
        
        
        let barButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40 ))
        barButtonView.backgroundColor = .black
        barButtonView.layer.cornerRadius = 20
        let imageForButton = UIImageView(image: self.avatarImage)
        barButtonView.addSubview(imageForButton)
        imageForButton.frame = barButtonView.frame
        imageForButton.contentMode = .scaleAspectFill
        let reconizer = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        imageForButton.addGestureRecognizer(reconizer)
        imageForButton.isUserInteractionEnabled = true
        barButtonView.clipsToBounds = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonView)
    }
    
    func createUI() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Tinkoff Chat"
        
        self.view.addSubview(userTableView)

        updImageProfile()
    }

    
    func getData(){
        users.append(tonyStark)
        users.append(lebowski)
        users.append(LebronJames)
        users.append(subZero)
        users.append(walterWhite)
        users.append(myDog)
        users.append(jessyPinkman)
        users.append(ilonMask)
        users.append(spam)
        users.append(sber)
        users.append(frodo)
        users.append(batman)
        users.append(deadpool)
        users.append(nogotochki)
        users.append(joker)
        users.append(morfeus)
        
    }
    
    // Метод для перехода к собщениям контакта
    func wantToTalk(to user: User){
        
        if user.hasUnreadMessages{
            updateUsersData(user: user, state: .hasUnreadMessages, value: false)
        }
        
        let chatView = ConversationViewController()
        chatView.user = user
        
        navigationController?.pushViewController(chatView, animated: true)
    }
    // Обновление состояниий пользователей
    func updateUsersData(user: User, state: User.ValueState, value: Bool){
        switch state {
        case .isOnline:
            if let index = self.users.firstIndex(where: { $0.name == user.name}){ self.users[index].isOnline = value }
        case .hasUnreadMessages:
            if let index = self.users.firstIndex(where: { $0.name == user.name}){ self.users[index].hasUnreadMessages = value }
        case .delete:
            if let index = self.users.firstIndex(where: { $0.name == user.name}){ self.users.remove(at: index)}
        case .isArchive:
            if let index = self.users.firstIndex(where: { $0.name == user.name}){ self.users[index].isArchive = value }
        
        }
    }
    
}

    //MARK: - Extensions
    
extension ConversationsListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Беседы"
        default:
            return "Архив"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        onlineArray = users.filter({user in !user.isArchive}).sorted(by: {$0.hasUnreadMessages == true && $1.hasUnreadMessages == false}).sorted(by: {$0.isOnline == true && $1.isOnline == false})
        historyArray = users.filter({user in user.isArchive}).sorted(by: {$0.hasUnreadMessages == true && $1.hasUnreadMessages == false}).sorted(by: {$0.isOnline == true && $1.isOnline == false})
        switch section {
        case 0:
            return onlineArray.count
        default:
            return historyArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserCell {
            cell.backgroundColor = .clear
            if indexPath.section == 0 {
                cell.user = onlineArray[indexPath.row]
            }else{
                cell.user = historyArray[indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

//MARK: - Extension TableView Delegate
extension ConversationsListViewController: UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            wantToTalk(to: onlineArray[indexPath.row])
        default:
            wantToTalk(to: historyArray[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let toHasUnreadMessage = UITableViewRowAction(style: .default, title: "Пометить непрочитанным"){ _, indexPath   in
            
            if indexPath.section == 0{
                self.updateUsersData(user: self.onlineArray[indexPath.row], state: .hasUnreadMessages, value: true)
                self.userTableView.reloadData()
            }
            
            if indexPath.section == 1 {
                self.updateUsersData(user: self.historyArray[indexPath.row], state: .hasUnreadMessages, value: true)
                self.userTableView.reloadData()
            }
        }
        let toArchiveButton = UITableViewRowAction(style: .default, title: "В архив") {_, indexpath in
            if indexPath.section == 0{
                self.updateUsersData(user: self.onlineArray[indexpath.row], state: .isArchive, value: true)
                self.userTableView.reloadData()
            }
            
            if indexPath.section == 1 {
                self.updateUsersData(user: self.historyArray[indexpath.row], state: .isArchive, value: false)
                self.userTableView.reloadData()
            }
            
        }
        
        toArchiveButton.backgroundColor = .systemGray

        if indexPath.section == 1 {
            toArchiveButton.title = "Вернуть"
            toArchiveButton.backgroundColor = .systemPurple
        }
        return [toArchiveButton, toHasUnreadMessage]
    }
    
  
}


