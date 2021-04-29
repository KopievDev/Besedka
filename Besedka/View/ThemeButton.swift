//
//  ThemeButton.swift
//  Besedka
//
//  Created by Ivan Kopiev on 07.03.2021.
//

import UIKit

class ThemeButton: UIButton {
    
    // MARK: - Properties
    lazy var formView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
        return view
    }()
    
    lazy var bubbleViewOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    lazy var bubbleViewTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.text = "Classic"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        createDesign()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createDesign()
    }
    
    // MARK: - Helpers
   private func createDesign() {
        addSubview(formView)
        addSubview(textLabel)
        self.formView.addSubview(bubbleViewOne)
        self.formView.addSubview(bubbleViewTwo)
        createConstraints()
        
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            formView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            formView.topAnchor.constraint(equalTo: self.topAnchor),
            formView.heightAnchor.constraint(equalToConstant: 60),
                        
            textLabel.topAnchor.constraint(greaterThanOrEqualTo: formView.bottomAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            bubbleViewOne.leadingAnchor.constraint(equalTo: formView.leadingAnchor, constant: 20),
            bubbleViewOne.topAnchor.constraint(equalTo: formView.topAnchor, constant: 10),
            bubbleViewOne.bottomAnchor.constraint(equalTo: formView.bottomAnchor, constant: -20),
            bubbleViewOne.trailingAnchor.constraint(equalTo: bubbleViewTwo.leadingAnchor, constant: -20),
            bubbleViewOne.widthAnchor.constraint(equalTo: bubbleViewTwo.widthAnchor),
                        
            bubbleViewTwo.topAnchor.constraint(equalTo: formView.topAnchor, constant: 20),
            bubbleViewTwo.bottomAnchor.constraint(equalTo: formView.bottomAnchor, constant: -10),
            bubbleViewTwo.trailingAnchor.constraint(equalTo: formView.trailingAnchor, constant: -20)
        ])
    }
    
}
