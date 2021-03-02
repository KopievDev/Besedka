//
//  UserCell.swift
//  Besedka
//
//  Created by Ivan Kopiev on 28.02.2021.
//

import UIKit

class UserCell: UITableViewCell {

    // MARK: - Properties
    let identifier = "cell"
    
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
        label.text = "Hi Bro! How are you??How are you??How are you??How are you?? How are you?? How are you?? How are you?? How are you?? How are you?? How are you?? "
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
        iv.backgroundColor = .gray
        iv.image = UIImage(named: "2")
        iv.translatesAutoresizingMaskIntoConstraints = false
    
        return iv
    }()
    //status
    private let isOnline: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
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
        self.isOnline.isHidden = true
        self.messageLabel.font = UIFont.systemFont(ofSize: 14)
        guard let user = user else {return}
        fullNameLabel.text = user.name
        if user.message != nil{
            messageLabel.text = user.message
        }else {
            messageLabel.font = UIFont.italicSystemFont(ofSize: 14)
            messageLabel.text = "No messages yet"
        }
        dateLabel.text = checkDate(date: user.date ?? Date())
        if !user.isOnline{
            self.isOnline.isHidden = true
        }else{
            self.isOnline.isHidden = false

        }
        if user.hasUnreadMessages {
            self.messageLabel.font = UIFont.boldSystemFont(ofSize: 14)
            self.messageLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 1)
            self.backgroundColor = #colorLiteral(red: 1, green: 0.9964868931, blue: 0.9576218565, alpha: 1)
        }
        
        
    }

    func checkDate(date: Date) -> String{
        let now = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let dayNow = calendar.component(.day, from: now)
        let monthNow = calendar.component(.month, from: now)
        let dateFormatter = DateFormatter()
        
        if month < monthNow || month == monthNow && day < dayNow{
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: date)
        }else {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
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
            isOnline.heightAnchor.constraint(equalToConstant: 12),
            isOnline.widthAnchor.constraint(equalToConstant: 12)

        ])
        
    }
}
