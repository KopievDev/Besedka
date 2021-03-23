//
//  LightTheme.swift
//  Besedka
//
//  Created by Ivan Kopiev on 11.03.2021.
//

import UIKit

struct LightTheme: ThemeProtocol {
   
    let tint: UIColor = .black
    let secondaryTint: UIColor = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)

    var buttonBackground: UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    let buttonDisable: UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)

    let backgroundColor: UIColor = .white
    let separatorColor: UIColor = .darkGray
    let selectionColor: UIColor = UIColor(red: 237/255, green: 237/255, blue: 240/255, alpha: 1)
    
    let labelColor: UIColor = .black
    let secondaryLabelColor: UIColor = .darkGray
    let subtleLabelColor: UIColor = .lightText
    var textFromMe: UIColor = .black

    let barStyle: UIBarStyle = .default
    let bubbleFromMe : UIColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
    let bubbleToMe : UIColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
    
    
}
