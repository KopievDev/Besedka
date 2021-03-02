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
        createUI()

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        createUI()
        print(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(#function)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)

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
    
    func createUI() {
        
        title = "Tinkoff Chat"
        self.view.addSubview(userTableView)
        navigationController?.navigationBar.prefersLargeTitles = true

        let defaults = UserDefaults.standard
        if let image = defaults.data(forKey: "saveImg"){
            self.avatarImage = UIImage(data: image, scale: 0.2) ?? UIImage()
        } else {
            self.avatarImage = UIImage(named: "2") ?? UIImage()
        }
        
        let nv = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35 ))
        nv.backgroundColor = .black
        nv.layer.cornerRadius = 35 / 2
        let im = UIImageView(image: self.avatarImage)
        nv.addSubview(im)
        im.frame = nv.frame
        let reconizer = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        im.addGestureRecognizer(reconizer)
        im.isUserInteractionEnabled = true
        nv.clipsToBounds = true
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: nv), animated: true)

    }

    
    func getData(){
        users.append(tonyStark)
        users.append(lebowski)
        users.append(LebronJames)
        
//        users.append(User(name: "Bro", message: "Hello", date: Date(timeIntervalSinceNow: -86660), isOnline: false, isArchive: true, hasUnreadMessages: true))
//        users.append(User(name: "Jon", message: "Я первый", date: Date(), isOnline: false, isArchive: false, hasUnreadMessages: false))
//        users.append(User(name: "Jully", message: "Hello rick dick pick", date: Date(), isOnline: false, isArchive: true, hasUnreadMessages: true))
//        users.append(User(name: "Koby", message: "Я второй еба", date: Date(), isOnline: true, isArchive: false, hasUnreadMessages: false))
//        users.append(User(name: "Lory", message: "Я третья", date: Date(timeIntervalSinceNow: -386660), isOnline: true, isArchive: false, hasUnreadMessages: false))
//        users.append(User(name: "Bob", message: "А я Боб", date: Date(), isOnline: true, isArchive: false, hasUnreadMessages: false))
//        users.append(User(name: "Vano", message: "А сверху Боб", date: Date(timeIntervalSinceNow: -863660), isOnline: true, isArchive: false, hasUnreadMessages: true))
//        users.append(User(name: "Jon", message: "Gays", date: Date(), isOnline: true, isArchive: true, hasUnreadMessages: false))
//        users.append(User(name: "Jony snow", message: "Gaydgdfgdsgdgs", date: Date(), isOnline: false, isArchive: false, hasUnreadMessages: true))
//        users.append(User(name: "Tony Stark", message: nil, date: Date(), isOnline: false, isArchive: true, hasUnreadMessages: false))

        
        onlineArray = users.filter({user in !user.isArchive}).sorted(by: {$0.hasUnreadMessages == true && $1.hasUnreadMessages == false}).sorted(by: {$0.isOnline == true && $1.isOnline == false})
        historyArray = users.filter({user in user.isArchive}).sorted(by: {$0.hasUnreadMessages == true && $1.hasUnreadMessages == false}).sorted(by: {$0.isOnline == true && $1.isOnline == false})
    }
    
}

    //MARK: - Extensions
    
extension ConversationsListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
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

               // UIColor(red: 0.255, green: 0.237, blue: 0.194, alpha: 1)
        }else{
            cell.user = historyArray[indexPath.row]
        }
        return cell
       }
        return UITableViewCell()
        
    }
    
    
    
}

//MARK: - Extension TableView Delegate
extension ConversationsListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Chats"
        default:
            return "History"
        }
    }
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
    
    func wantToTalk(to user: User)  {
        let chatView = ConversationViewController()
        chatView.user = user
        navigationController?.navigationBar.prefersLargeTitles = false

        navigationController?.pushViewController(chatView, animated: true)
    }
}


