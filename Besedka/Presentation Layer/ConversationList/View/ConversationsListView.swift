//
//  Cn.swift
//  Besedka
//
//  Created by Ivan Kopiev on 15.04.2021.
//

import UIKit

class ConversationsListView: UIView {

    lazy var addChannelButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = Theme.current.secondaryTint
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    // MARK: - Lifecycle
    init(frame: CGRect, radius: CGFloat) {
        super.init(frame: frame)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addButtonChannels() {
        let button = UIButton(type: .system)
        self.addSubview(button)
        button.frame = CGRect(x: self.frame.width - self.frame.width / 5 - 20,
                              y: self.frame.height - self.frame.width / 5 - 50,
                              width: self.frame.width / 6, height: self.frame.width / 6)
        button.tintColor = UIColor(red: 1.00, green: 0.42, blue: 0.42, alpha: 1.00)
        button.addCornerRadius(button.frame.width / 2)
        button.backgroundColor = .white

        button.setImage(UIImage(named: "add"), for: .normal)
//        button.addTarget(self, action: #selector(addNewChannel), for: .touchUpInside)
    }

}
