//
//  DarkTheme.swift
//  Besedka
//
//  Created by Ivan Kopiev on 10.03.2021.
//

import UIKit

struct DarkTheme: ThemeProtocolSec {
  
    let tint: UIColor = .white
    let secondaryTint: UIColor = .green

    var buttonBackground: UIColor = UIColor(red: 0.106, green: 0.106, blue: 0.106, alpha: 1)
    let backgroundColor: UIColor = .black
    let separatorColor: UIColor = .darkGray
    let selectionColor: UIColor = .init(red: 38/255, green: 38/255, blue: 40/255, alpha: 1)

    let labelColor: UIColor = .white
    let secondaryLabelColor: UIColor = .lightGray
    let subtleLabelColor: UIColor = .darkGray
    var textFromMe: UIColor = .white

    let barStyle: UIBarStyle = .blackOpaque
    let bubbleFromMe : UIColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
    let bubbleToMe : UIColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)

}




