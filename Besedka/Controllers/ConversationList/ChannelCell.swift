//
//  UserCell.swift
//  Besedka
//
//  Created by Ivan Kopiev on 28.02.2021.
//

import UIKit

class UserCell: UITableViewCell {

    // MARK: - Properties
    
    // username
     let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Last message
    private let messageLabel: SecondaryLabel = {
        let label = SecondaryLabel()
        label.text = "Hi Bro! How are you??"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    // Date label
    private let dateLabel: SecondaryLabel = {
        let label = SecondaryLabel()
        label.text = "25.01.21"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Image of contacts
    private let contactImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 48 / 2
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor(red: 0.40, green: 0.80, blue: 0.67, alpha: 1.00)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let shortName: UILabel = {
        let label = SecondaryLabel()
        label.text = "N"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     // MARK: - Helpers
    
    func createUI() {

        addSubview(contactImageView)
        addSubview(fullNameLabel)
        addSubview(dateLabel)
        addSubview(messageLabel)
        contactImageView.addSubview(shortName)
        createConstrains()
      
    }
    
    func configureCell(_ channel: Channel?) {
        self.backgroundColor = .clear
        self.messageLabel.font = UIFont.systemFont(ofSize: 14)
        self.shortName.text = channel?.name.first?.uppercased()
        guard let channel = channel else {return}
        
        fullNameLabel.text = channel.name
        if channel.lastMessage != "" {
            messageLabel.text = channel.lastMessage
        } else {
            messageLabel.font = UIFont.italicSystemFont(ofSize: 14)
            messageLabel.text = "No messages yet"
        }
        dateLabel.text = channel.lastActivity?.formatedDate()
    }
        
    func createConstrains() {

        NSLayoutConstraint.activate([
            
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: fullNameLabel.trailingAnchor, constant: 6),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50), // Работа над ошибками
            
            fullNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70),
            fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 36),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            
            contactImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contactImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contactImageView.heightAnchor.constraint(equalToConstant: 48),
            contactImageView.widthAnchor.constraint(equalToConstant: 48),

            shortName.centerYAnchor.constraint(equalTo: contactImageView.centerYAnchor),
            shortName.centerXAnchor.constraint(equalTo: contactImageView.centerXAnchor)

        ])
    
    }
}
