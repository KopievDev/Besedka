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
        print(#function)
        self.userTableView.reloadData()
        updateImageProfile()

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(#function)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)

    }
    //MARK: - Selectors
    @objc func showProfile(){
        let profileViewController = ProfileViewController()
        profileViewController.radius = (self.view.frame.width - 140) * 0.5
        profileViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(profileViewController, animated: true)
    }
    
  
    //MARK: - Helpers
    
    fileprivate func updateImageProfile() {
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

        updateImageProfile()
        addSettingButton()
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
        users.append(prapor)
        users.append(gagarin)
        users.append(anonym)

    }
    
    // Метод для перехода к собщениям контакта
    func wantToTalk(to user: User){
        
        if user.hasUnreadMessages{updateUsersData(user: user, state: .hasUnreadMessages, value: false)}
        
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

    //MARK: - Extensions TableView DataSource
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserCell else {return UITableViewCell()}
        cell.backgroundColor = .clear
        switch indexPath.section {
        case 0:
            cell.configureCell(user: onlineArray[indexPath.row])
        default:
            cell.configureCell(user: historyArray[indexPath.row])
        }
        
        return cell
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
        let toHasUnreadMessage = UITableViewRowAction(style: .default, title: "Пометить непрочитанным"){ _,_  in

            switch indexPath.section {
            case 0:
                self.updateUsersData(user: self.onlineArray[indexPath.row], state: .hasUnreadMessages, value: true)
            default:
                self.updateUsersData(user: self.historyArray[indexPath.row], state: .hasUnreadMessages, value: true)
            }
            self.userTableView.reloadData()

        }
        let toArchiveButton = UITableViewRowAction(style: .default, title: "В архив") {_,_ in
            switch indexPath.section {
            case 0:
                self.updateUsersData(user: self.onlineArray[indexPath.row], state: .isArchive, value: true)
            default:
                self.updateUsersData(user: self.historyArray[indexPath.row], state: .isArchive, value: false)
            }

            self.userTableView.reloadData()

        }
        
        toArchiveButton.backgroundColor = .systemGray
        
        if indexPath.section == 1 {
            toArchiveButton.title = "Вернуть"
            toArchiveButton.backgroundColor = .systemPurple
        }
        return [toArchiveButton, toHasUnreadMessage]
    }

  
}


//MARK: - Homework #4.2

extension ConversationsListViewController {
    
    func addSettingButton(){
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(goToSetting)), animated: true)
    }
    
    
    @objc func goToSetting(){
        let settingView = ThemesViewController()
        
        //Clouser
        settingView.themeSelected = {[weak self] theme in
            self?.changeTheme(name: theme)
        }
        
        //Delegate
        settingView.delegate = self
        
        navigationController?.pushViewController(settingView, animated: true)

    }
}

//MARK: - Delegate ThemeProtocol  - Homework #4.3
extension ConversationsListViewController: ThemeDelegateProtocol{
    
    func changeTheme(name: String) {
        switch name {
        case "Classic":
            Theme.current = LightTheme()
            print("Light Theme On")
        case "Day":
            Theme.current = DayTheme()
            print("Day Theme On")
        default:
            Theme.current = DarkTheme()
            print("Night Theme On")
        }
        Theme.current.apply(for: UIApplication.shared)
    }
}


