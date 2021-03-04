//
//  UserCell.swift
//  Besedka
//
//  Created by Ivan Kopiev on 28.02.2021.
//

import UIKit

class UserCell: UITableViewCell {

    // MARK: - Properties    
    var user : User? {
        didSet{configure()}
    }
    // username
     let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    //Last message
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi Bro! How are you??"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    //Date label
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "25.01.21"
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Image of contacts
    private let contactImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 48 / 2
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .gray
        iv.image = UIImage(named: "Anonimous")
        iv.translatesAutoresizingMaskIntoConstraints = false
    
        return iv
    }()
    //status
    private let isOnline: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(red: 0.353, green: 0.831, blue: 0.224, alpha: 1)
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        view.translatesAutoresizingMaskIntoConstraints = false
      
        return view
    }()
    
    
    
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

     //MARK: - Helpers
    
    func createUI() {
        
        addSubview(contactImageView)
        addSubview(fullNameLabel)
        addSubview(dateLabel)
        addSubview(messageLabel)
        addSubview(isOnline)
        createConstrains()
      
    }
    
    func configure()  {
        self.backgroundColor = .clear
        //self.isOnline.backgroundColor = .darkGray
        self.messageLabel.font = UIFont.systemFont(ofSize: 14)
        self.contactImageView.image = UIImage(named: "Anonymous")
        
        guard let user = user else {return}
        if user.image != nil {
            self.contactImageView.image = UIImage(named: user.image ?? "Anonymous")
        }
        fullNameLabel.text = user.name ?? "Незвестный"
        if user.lastMessage != nil{
            messageLabel.text = user.lastMessage
        }else {
            messageLabel.font = UIFont.italicSystemFont(ofSize: 14)
            messageLabel.text = "No messages yet"
        }
        dateLabel.text = user.date?.checkDate()
        if !user.isOnline{
            self.isOnline.backgroundColor = .darkGray

//            self.isOnline.isHidden = true
        }else{
           // self.isOnline.isHidden = false
            self.isOnline.backgroundColor = UIColor(red: 0.353, green: 0.831, blue: 0.224, alpha: 1)

        }
        if user.hasUnreadMessages {
            self.messageLabel.font = UIFont.boldSystemFont(ofSize: 14)
            self.messageLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 1)
            self.backgroundColor = #colorLiteral(red: 1, green: 0.9964868931, blue: 0.9576218565, alpha: 1)
        }
        
        
    }
    
    func createConstrains(){
        

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: fullNameLabel.trailingAnchor, constant: 6),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
            
            
        ])
        NSLayoutConstraint.activate([
            fullNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70),
            fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
            
            
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 36),
            messageLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 70),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
            
        ])
        
        NSLayoutConstraint.activate([
            contactImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contactImageView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant: 10),
            contactImageView.heightAnchor.constraint(equalToConstant: 48),
            contactImageView.widthAnchor.constraint(equalToConstant: 48)

        ])
        NSLayoutConstraint.activate([
            isOnline.topAnchor.constraint(equalTo: self.contactImageView.topAnchor, constant: 4),
            isOnline.leadingAnchor.constraint(equalTo: self.contactImageView.leadingAnchor, constant: 37),
            isOnline.heightAnchor.constraint(equalToConstant: 16),
            isOnline.widthAnchor.constraint(equalToConstant: 16)

        ])
        
    }
}


