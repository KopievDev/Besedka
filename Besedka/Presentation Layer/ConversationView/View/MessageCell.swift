//
//  MessageCell.swift
//  Besedka
//
//  Created by Ivan Kopiev on 02.03.2021.
//

import UIKit

class MessageCell: UITableViewCell {
    
    // MARK: - Properties

    var widthMessage: CGFloat = 0
    // MARK: - UI
    // TextView
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.text = "Test teste test"
        textView.textColor = Theme.current.labelColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // Date
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.text = "23:23"
        label.textColor = Theme.current.secondaryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // BubbleView
    let bubbleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.current.bubbleFromMe
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.text = "Bro"
        label.textColor = Theme.current.secondaryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Constrains
    var leftBubble = NSLayoutConstraint()
    var rightBubble = NSLayoutConstraint()
    var widthBubble = NSLayoutConstraint()
    var textViewTopFromMe = NSLayoutConstraint()

        // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        fatalError("init(coder:) has not been implemented")

    }
    
    // MARK: - Helpers
    func configureCell(message: MessageDB?) {
        // Обнуление ячейки
        self.backgroundColor = .clear
        name.isHidden = true
        textView.textColor = Theme.current.labelColor
        dateLabel.textColor = Theme.current.secondaryLabelColor

        // Ширина сообщения
        widthBubble = bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: widthMessage )
        widthBubble.isActive = true
        // Передача данных
        guard let message = message else {return}
        textView.text = message.content
        name.text = message.senderName
        if message.senderId == myId {
            rightBubble.isActive = true
            textViewTopFromMe.isActive = true
            bubbleContainer.backgroundColor = Theme.current.bubbleFromMe
            textView.textColor = Theme.current.textFromMe
            dateLabel.textColor = Theme.current.textFromMe
        } else {
            leftBubble.isActive = true
            name.isHidden = false
            bubbleContainer.backgroundColor = Theme.current.bubbleToMe
        }
        dateLabel.text = message.created.formatedDate()
     
    }
    
    func  createUI() {
        addSubview(bubbleContainer)
        bubbleContainer.addSubview(textView)
        bubbleContainer.addSubview(dateLabel)
        bubbleContainer.addSubview(name)

        createConstrains()
    }
    
    func createConstrains() {
        
        leftBubble = bubbleContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        rightBubble = bubbleContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        textViewTopFromMe = textView.topAnchor.constraint(equalTo: bubbleContainer.topAnchor, constant: 4)

        NSLayoutConstraint.activate([
            // BubbleView
            bubbleContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            bubbleContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            bubbleContainer.widthAnchor.constraint(greaterThanOrEqualTo: self.widthAnchor, multiplier: 0.3),
            // name
            name.topAnchor.constraint(equalTo: bubbleContainer.topAnchor, constant: 5),
            name.leadingAnchor.constraint(equalTo: bubbleContainer.leadingAnchor, constant: 6),
            name.trailingAnchor.constraint(equalTo: bubbleContainer.trailingAnchor, constant: -12),
            name.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: 5),
            // TextView
//            textView.topAnchor.constraint(equalTo: bubbleContainer.topAnchor, constant: 4),
            textView.leadingAnchor.constraint(equalTo: bubbleContainer.leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: bubbleContainer.trailingAnchor, constant: -12),
            textView.widthAnchor.constraint(greaterThanOrEqualToConstant: widthMessage * 0.3),
            // DateLabel
            dateLabel.topAnchor.constraint(equalTo: textView.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 5),
            dateLabel.bottomAnchor.constraint(equalTo: bubbleContainer.bottomAnchor, constant: -5)
        ])
        
    }

}
