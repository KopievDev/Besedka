//
//  LightTheme.swift
//  Besedka
//
//  Created by Ivan Kopiev on 11.03.2021.
//

import UIKit

struct LightTheme: ThemeProtocolSec {
   
    let tint: UIColor = .black
    let secondaryTint: UIColor = .green

    var buttonBackground: UIColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
    let backgroundColor: UIColor = .white
    let separatorColor: UIColor = .darkGray
    let selectionColor: UIColor = .lightGray

    let labelColor: UIColor = .black
    let secondaryLabelColor: UIColor = .darkGray
    let subtleLabelColor: UIColor = .darkGray
    var textFromMe: UIColor = .black

    let barStyle: UIBarStyle = .default
    let bubbleFromMe : UIColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
    let bubbleToMe : UIColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
    
    
}
