//
//  DarkTheme.swift
//  Besedka
//
//  Created by Ivan Kopiev on 10.03.2021.
//

import UIKit

struct DarkTheme: ThemeProtocol {
  
    let tint: UIColor = .white
    let secondaryTint: UIColor = UIColor(red: 0.44, green: 0.50, blue: 0.56, alpha: 0.6)

    let buttonBackground: UIColor = UIColor(red: 0.106, green: 0.106, blue: 0.106, alpha: 1)
    let buttonDisable: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)

    let backgroundColor: UIColor = .black
    let separatorColor: UIColor = .darkGray
    let selectionColor: UIColor = .init(red: 38/255, green: 38/255, blue: 40/255, alpha: 1)

    let labelColor: UIColor = .white
    let secondaryLabelColor: UIColor = .darkGray
    let subtleLabelColor: UIColor = .darkGray
    var textFromMe: UIColor = .white

    let barStyle: UIBarStyle = .blackOpaque
    let bubbleFromMe : UIColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
    let bubbleToMe : UIColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
    
       
}


extension DarkTheme{
    func extend(){
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = Theme.current.labelColor
    }
}


