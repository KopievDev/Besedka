//
//  ConversationsListViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 28.02.2021.
//

import UIKit
import CoreData
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
    // CoreData
    var core: CoreDataStack?
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<ChannelDB>()
    
    var arrayChannels = [ChannelDB]()
    
    lazy var channels: [Channel] = [] {
        didSet {
            core?.performSave { context in
                
                // Добавляем/обновляем каналы с сервера
                self.channels.forEach { channel in
                    
                    let channel = ChannelDB(channel, context: context)
                    self.arrayChannels.append(channel)
                }
                
                let request: NSFetchRequest = ChannelDB.fetchRequest()
                do {
                    let currentChannel = try context.fetch(request)
                    // Перебираем массив каналов из памяти и сравниваем с каналами из сервера (удаляем каналы, которых уже нет на сервере)
                    currentChannel.forEach {
                        if !self.arrayChannels.contains($0) {
                            context.delete($0)
                        }
                    }
                    
                } catch {
                    print(error)
                }
                do {
                    try context.obtainPermanentIDs(for: arrayChannels )
                } catch let error {
                    print(error, "obtain error")
                }
            }
            // Создаем запрос для получения всех каналов из памяти
            core?.printChannelsCount()
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
        initFectedResultController()
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
        button.tintColor = UIColor(red: 1.00, green: 0.42, blue: 0.42, alpha: 1.00)
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
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn) {
            viewToAnimate.transform = .identity
            
        }
    }
    
//     Метод для перехода к собщениям контакта
    func wantToTalk(in channel: Channel) {
        let chatView = ConversationViewController()
        chatView.coreDataStack = self.core
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let numberOfSections = fetchedResultController.sections?.count else {return 0}
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserCell else {return UITableViewCell()}
        let channel = fetchedResultController.object(at: indexPath as IndexPath)
        cell.backgroundColor = .clear
        cell.configureCell(channel)
        return cell
    }
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cellUpdate = cell as? UserCell else {return}
        // get managed object
        let channel = self.fetchedResultController.object(at: indexPath)
        // Configure Cell
        cellUpdate.configureCell(channel)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Channels"
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
            let channel = self.fetchedResultController.object(at: indexPath)
            self.core?.delete(channel: channel.name)
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

// MARK: - FetchedResultController

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func initFectedResultController() {
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {
        }
    }
    
    func getFetchedResultController() -> NSFetchedResultsController<ChannelDB> {
        guard let context = core?.mainContext else {return NSFetchedResultsController<ChannelDB>()}
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(),
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest<ChannelDB> {
        let fetchRequest: NSFetchRequest = ChannelDB.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        channelsTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                channelsTableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:            
            if let indexPath = indexPath {
                channelsTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = channelsTableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
            }
            
        case .move:
            if let indexPath = indexPath {
                channelsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                channelsTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            
        @unknown default:
            fatalError("erororoorororo")
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        channelsTableView.endUpdates()
    }
    
}
