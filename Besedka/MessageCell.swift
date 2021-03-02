//
//  MessageCell.swift
//  Besedka
//
//  Created by Ivan Kopiev on 02.03.2021.
//

import UIKit

class MessageCell: UITableViewCell {
    
    //MARK: - Properties
    var message : Messages? {
        didSet{configure()}
    }
    
    //MARK: - UI
    //TextView
    private let textView : UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.text = "Test teste test"
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //Date
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.text = "23:23"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //BubbleView
    let bubbleContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    //Constrains
    var leftBuuble = NSLayoutConstraint()
    var rightBubble = NSLayoutConstraint()
    
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- Helpers
    func configure()  {
        guard let message = message else {return}
        print(message.message ?? "huy tibe")
        
        textView.text = message.message
        
        
        if message.toMe {
            leftBuuble.isActive = true
        } else {
            rightBubble.isActive = true
        }
     
    }
    
    func  createUI() {
        addSubview(bubbleContainer)
        bubbleContainer.addSubview(textView)
        bubbleContainer.addSubview(dateLabel)
        createConstrains()
    }
    
    func createConstrains() {
        
        leftBuuble = bubbleContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        leftBuuble.isActive = false
        rightBubble = bubbleContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        rightBubble.isActive = false
        let widthMessage = self.frame.width * 3 / 4
        NSLayoutConstraint.activate([
            //BubbleView
            bubbleContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: widthMessage),
                            
            //TextView
            textView.topAnchor.constraint(equalTo: bubbleContainer.topAnchor, constant: 4),
            textView.leadingAnchor.constraint(equalTo: bubbleContainer.leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: bubbleContainer.trailingAnchor, constant: -12),
            //DateLabel
            dateLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bubbleContainer.bottomAnchor, constant: -4)
            
        ])
        
    }


}

