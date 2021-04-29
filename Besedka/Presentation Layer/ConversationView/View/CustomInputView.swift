//
//  CustomInputView.swift
//  Besedka
//
//  Created by Ivan Kopiev on 22.03.2021.
//
import UIKit

class CustomInputAccesoryView: UIView {
    
    // MARK: - Properties
    
    public let messageInputTextView: UITextView = {
       let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    public let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(Theme.current.labelColor, for: .normal)
        button.setTitleColor(Theme.current.secondaryLabelColor, for: .highlighted)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let placeholderLabel: UILabel = {
       let label = UILabel()
        label.textColor = Theme.current.secondaryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter message"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var heightText = self.messageInputTextView.heightAnchor.constraint(equalToConstant: 100)

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createDesign()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createDesign()
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return textViewContentSize()
    }
    
    // MARK: - Helpers
    
    fileprivate func createDesign() {
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = Theme.current.tint.cgColor
        
        backgroundColor = Theme.current.backgroundColor
        autoresizingMask = .flexibleHeight
        addSubview(messageInputTextView)
        addSubview(sendButton)
        addSubview(placeholderLabel)
        createConstraints()
    }
    
    fileprivate func createConstraints() {
        
        NSLayoutConstraint.activate([
            // Button
            sendButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 4),
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            // TextView
            messageInputTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            messageInputTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            messageInputTextView.trailingAnchor.constraint(equalTo: self.sendButton.leadingAnchor, constant: -10),
            messageInputTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            // Placeholder
            placeholderLabel.leadingAnchor.constraint(equalTo: messageInputTextView.leadingAnchor, constant: 4),
            placeholderLabel.centerYAnchor.constraint(equalTo: messageInputTextView.centerYAnchor)
            
        ])
    }
    
    func textViewContentSize() -> CGSize {
        let size = CGSize(width: messageInputTextView.bounds.width,
                          height: CGFloat.greatestFiniteMagnitude)
     
        let textSize = messageInputTextView.sizeThatFits(size)
        return CGSize(width: bounds.width, height: textSize.height)
    }
    
    // MARK: - Selectors
    
    @objc func sendMessage() {
        
    }
    
}
