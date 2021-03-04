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
    var widthMessage : CGFloat = 0
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
    var leftBubble = NSLayoutConstraint()
    var rightBubble = NSLayoutConstraint()
    var widthBubble = NSLayoutConstraint()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        fatalError("init(coder:) has not been implemented")

    }
    
    
    //MARK:- Helpers
    func configure()  {
        // Ширина сообщения
        widthBubble = bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant:widthMessage )
        widthBubble.isActive = true
        //Передача данных
        guard let message = message else {return}
        textView.text = message.message
        
        if message.toMe {
            leftBubble.isActive = true
            bubbleContainer.backgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
        } else {
            rightBubble.isActive = true
            bubbleContainer.backgroundColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
        }
        dateLabel.text = message.date?.checkDate()
     
    }
    
    func  createUI() {
        addSubview(bubbleContainer)
        bubbleContainer.addSubview(textView)
        bubbleContainer.addSubview(dateLabel)
        createConstrains()
    }
    
    func createConstrains() {
        
        leftBubble = bubbleContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        leftBubble.isActive = false
        rightBubble = bubbleContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        rightBubble.isActive = false

        NSLayoutConstraint.activate([
            //BubbleView
            bubbleContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            bubbleContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            //TextView
            textView.topAnchor.constraint(equalTo: bubbleContainer.topAnchor, constant: 4),
            textView.leadingAnchor.constraint(equalTo: bubbleContainer.leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: bubbleContainer.trailingAnchor, constant: -12),
            textView.widthAnchor.constraint(greaterThanOrEqualToConstant: widthMessage * 0.3),
            //DateLabel
            dateLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: -10),
            dateLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 5),
            dateLabel.bottomAnchor.constraint(equalTo: bubbleContainer.bottomAnchor, constant: -4)
            
        ])
        
    }


}
