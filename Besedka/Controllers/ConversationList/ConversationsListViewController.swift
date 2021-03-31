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
    
    lazy var channels: [Channel] = [] {
        didSet {
            CoreDataStack.defaultStack.performSave { [channels] context in
                channels.forEach { channel in
                    _ = ChannelDB(channel, context: context)
                }
                
                CoreDataStack.defaultStack.printChannelsCount()
            }
        }
    }
    
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
        addListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        channelsTableView.reloadData()
        updateImageProfile()
        addButtonChannels()
        
    }
    // MARK: - Selectors
    @objc func showProfile() {
        let profileViewController = ProfileViewController()
        profileViewController.radius = (self.view.frame.width - 140) * 0.5
        profileViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(profileViewController, animated: true)
    }
  
    // MARK: - Helpers
    
    private func addListener() {
        firebase.addSortedChannelListener { (channels) in
            self.channels = channels
            self.channelsTableView.reloadData()
        }
    }
    
    fileprivate func addButtonChannels() {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        button.frame = CGRect(x: self.view.frame.width - self.view.frame.width / 5 - 20,
                              y: self.view.frame.height - self.view.frame.width / 5 - 50,
                              width: self.view.frame.width / 6, height: self.view.frame.width / 6)
        button.tintColor = .systemPurple
        button.addCornerRadius(button.frame.width / 2)
        button.backgroundColor = .white

        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self, action: #selector(addNewChannel), for: .touchUpInside)
    }
    
    fileprivate func updateImageProfile() {
        let barButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40 ))
        barButtonView.backgroundColor = .black
        barButtonView.layer.cornerRadius = 20
        let imageForButton = UIImageView()
        imageForButton.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1)
        imageForButton.tintColor = Theme.current.tint
        barButtonView.addSubview(imageForButton)
        imageForButton.frame = barButtonView.frame
        imageForButton.contentMode = .scaleAspectFill
        let shortName = UILabel()
        shortName.frame = imageForButton.frame
        shortName.font = .boldSystemFont(ofSize: 20)
        shortName.textAlignment = .center
        imageForButton.addSubview(shortName)
        let reconizer = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        imageForButton.addGestureRecognizer(reconizer)
        imageForButton.isUserInteractionEnabled = true
        barButtonView.clipsToBounds = true
        let fileOpener = FileManagerGCD()
        fileOpener.getUser { (user) in
            // Get short name from name
            let text = user?.name ?? ""
            if text.split(separator: " ").count >= 2 {
                shortName.text = "\(text.split(separator: " ")[0].first ?? "n")\(text.split(separator: " ")[1].first ?? "n")".uppercased()
            } else {
                shortName.text = text.first?.uppercased()
            }
            
        }
        fileOpener.getImageFromFile(name: "Avatar.png",
                                    runQueue: .global(qos: .utility), completionQueue: .main) {(image) in
            imageForButton.image = image
            shortName.isHidden = true
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonView)
    }
    
    func createUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Tinckoff Chat"
        self.view.addSubview(channelsTableView)
        self.view.addSubview(addChannelButton)
        updateImageProfile()
        addSettingButton()
        
    }
    
    private func animateView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            viewToAnimate.transform = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi * -3 / 4))
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn) {
            viewToAnimate.transform = .identity
            
        }
    }
    
//     Метод для перехода к собщениям контакта
    func wantToTalk(in channel: Channel) {
        let chatView = ConversationViewController()
        chatView.channel = channel
        navigationController?.pushViewController(chatView, animated: true)
    }
    
    // MARK: - Selectors
    
    @objc func addNewChannel(sender: UIButton) {
        animateView(sender)

        let alert = UIAlertController(title: nil, message: "Введите название канала:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Название"
        }
        let applyButton = UIAlertAction(title: "Создать", style: .default) {[weak self] (_) in
            guard let name = alert.textFields?.first?.text else {return}
            guard let self = self else { return }
            if name != "" {
                self.firebase.addNew(channel: Channel(name: name))
            }
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(applyButton)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func rename(channel: Channel) {
        let alert = UIAlertController(title: nil, message: "Введите новое название канала:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = channel.name
        }
        let applyButton = UIAlertAction(title: "Переименовать", style: .default) {[weak self] (_) in
            guard let name = alert.textFields?.first?.text else {return}
            guard let self = self else { return }
            if name != "" {
                self.firebase.rename(channel, to: name)
            }
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(applyButton)
        alert.addAction(cancel)
        present(alert, animated: true)
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
        let deleteChannel = UITableViewRowAction(style: .default, title: "delete") { _, _  in
            self.firebase.delete(self.channels[indexPath.row])
        }
        
        let renameChannel = UITableViewRowAction(style: .default, title: "rename") {_, _ in
            self.rename(channel: self.channels[indexPath.row])
        }
        
        deleteChannel.backgroundColor = .systemRed
        renameChannel.backgroundColor = .systemPurple
        
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
