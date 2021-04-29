//
//  DayTheme.swift
//  Besedka
//
//  Created by Ivan Kopiev on 11.03.2021.
//

import UIKit

struct DayTheme: ThemeProtocol {
    
    let labelColor: UIColor = .black
    let secondaryLabelColor: UIColor = .darkGray
    let subtleLabelColor: UIColor = .lightGray
    var textFromMe: UIColor = .white

    let tint: UIColor = UIColor(red: 0.00, green: 0.50, blue: 0.50, alpha: 1.00)
    let secondaryTint: UIColor = UIColor(red: 0.40, green: 0.80, blue: 0.67, alpha: 0.4)

    let buttonBackground: UIColor = UIColor(red: 1.00, green: 0.85, blue: 0.73, alpha: 1.00)
    let buttonDisable: UIColor = UIColor(red: 1.00, green: 0.95, blue: 0.8, alpha: 1.00)

    let backgroundColor: UIColor = UIColor(red: 1.00, green: 0.98, blue: 0.98, alpha: 1.00)
    let separatorColor: UIColor = .darkGray
    let selectionColor: UIColor = UIColor(red: 1.00, green: 0.63, blue: 0.48, alpha: 0.1)

    let barStyle: UIBarStyle = .default
    let bubbleFromMe: UIColor = UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
    let bubbleToMe: UIColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
    
}
