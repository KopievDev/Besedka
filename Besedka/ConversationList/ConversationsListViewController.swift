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

        createUI()

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
        
        navigationController?.navigationBar.prefersLargeTitles = true

        title = "Tinkoff Chat"
        self.view.addSubview(userTableView)

        let defaults = UserDefaults.standard
        if let image = defaults.data(forKey: "saveImg"){
            self.avatarImage = UIImage(data: image, scale: 0.2) ?? UIImage()
        } else {
            self.avatarImage = UIImage(named: "Anonymous") ?? UIImage()
        }
        
        let nv = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35 ))
        nv.backgroundColor = .black
        nv.layer.cornerRadius = 35 / 2
        let im = UIImageView(image: self.avatarImage)
        nv.addSubview(im)
        im.frame = nv.frame
        im.contentMode = .scaleAspectFill
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
        
    }
    
}

    //MARK: - Extensions
    
extension ConversationsListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
    
    func wantToTalk(to user: User){
        
        if user.hasUnreadMessages{
            if let index = self.users.firstIndex(where: { currentUser in currentUser.name == user.name}){
                self.users[index].hasUnreadMessages = false
            }
        }
        
        let chatView = ConversationViewController()
        chatView.user = user
        
        // chatView.configureNavigationBar(withTitle: user.name, prefersLargeTitles: false)
        navigationController?.pushViewController(chatView, animated: true)
    }
}


