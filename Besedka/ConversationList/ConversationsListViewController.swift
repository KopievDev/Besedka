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
    private lazy var channelsTableView: UITableView = {
        let table = UITableView(frame: view.frame, style: .plain)
        table.register(UserCell.self, forCellReuseIdentifier: cellId)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var channels = [Channel]()
    lazy var addChannelButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = Theme.current.secondaryTint
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    let firebase = FirebaseService()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        let firebase = FirebaseService()
        
        firebase.addChannelListener { (channels) in
            self.channels = channels
            self.channelsTableView.reloadData()
            self.channels.forEach { channel in
                print(channel.identifier!, channel.name)
                print(channel.lastMessage!)
                print()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        self.channelsTableView.reloadData()
        updateImageProfile()

    }
    // MARK: - Selectors
    @objc func showProfile() {
        let profileViewController = ProfileViewController()
        profileViewController.radius = (self.view.frame.width - 140) * 0.5
        profileViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(profileViewController, animated: true)
    }
  
    // MARK: - Helpers
    
    fileprivate func updateImageProfile() {
        let barButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40 ))
        barButtonView.backgroundColor = .black
        barButtonView.layer.cornerRadius = 20
        let imageForButton = UIImageView(image: UIImage(named: "Anonymous"))
        barButtonView.addSubview(imageForButton)
        imageForButton.frame = barButtonView.frame
        imageForButton.contentMode = .scaleAspectFill
        let reconizer = UITapGestureRecognizer(target: self, action: #selector(self.showProfile))
        imageForButton.addGestureRecognizer(reconizer)
        imageForButton.isUserInteractionEnabled = true
        barButtonView.clipsToBounds = true
        let fileOpener = FileManagerGCD()
        fileOpener.getImageFromFile(name: "Avatar.png",
                                    runQueue: .global(qos: .utility), completionQueue: .main) {(image) in
            imageForButton.image = image
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonView)
    }
    
    func createUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Tinckoff Chat"
        self.view.addSubview(channelsTableView)
        self.view.addSubview(addChannelButton)
        self.addChannelButton = UIButton(frame: CGRect(x: self.view.frame.maxX - 70,
                                                       y: self.view.frame.maxY - 70,
                                                       width: 50,
                                                       height: 50))
        addChannelButton.backgroundColor = .green
        updateImageProfile()
        addSettingButton()
        
    }
    
//     Метод для перехода к собщениям контакта
    func wantToTalk(in channel: Channel) {
        let chatView = ConversationViewController()
        chatView.channel = channel
        navigationController?.pushViewController(chatView, animated: true)
    }
    
}

    // MARK: - Extensions TableView DataSource
    
extension ConversationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Channels"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserCell else {return UITableViewCell()}
        cell.backgroundColor = .clear
        cell.configureCell(self.channels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - Extension TableView Delegate
extension ConversationsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        wantToTalk(in: self.channels[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteChannel = UITableViewRowAction(style: .default, title: "Удалить") { _, _  in
            self.firebase.delete(self.channels[indexPath.row])
        }
        
        let renameChannel = UITableViewRowAction(style: .default, title: "Переименовать") {_, _ in
            self.firebase.rename(self.channels[indexPath.row], to: "Флудилка #")
        }
        
        deleteChannel.backgroundColor = .systemPurple
        renameChannel.backgroundColor = .systemGray
        
        return [deleteChannel, renameChannel]
    }
    
}

// MARK: - Homework #4.2

extension ConversationsListViewController {
    
    func addSettingButton() {
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(goToSetting)), animated: true)
    }
    
    @objc func goToSetting() {
        let settingView = ThemesViewController()
        
        // Clouser
        settingView.themeSelected = {[weak self] theme in
            self?.changeTheme(name: theme)
        }
        
        // Delegate
        settingView.delegate = self
        
        navigationController?.pushViewController(settingView, animated: true)

    }
}

// MARK: - Delegate ThemeProtocol  - Homework #4.3
extension ConversationsListViewController: ThemeDelegateProtocol {
    
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
