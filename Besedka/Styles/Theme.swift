//
//  Theme.swift
//  Besedka
//
//  Created by Ivan Kopiev on 10.03.2021.
//

import UIKit

class Theme {
    static var current: ThemeProtocol = DarkTheme()
}

protocol ThemeProtocol {
    
    var tint: UIColor { get }
    var secondaryTint: UIColor { get }
    
    var backgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var selectionColor: UIColor { get }
    
    var labelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var subtleLabelColor: UIColor { get }
    
    var barStyle: UIBarStyle { get }
    var bubbleFromMe: UIColor {get}
    var bubbleToMe: UIColor {get}
    
    var buttonBackground: UIColor {get}
    var buttonDisable: UIColor {get}
    var textFromMe: UIColor {get}
    
    func apply(for application: UIApplication)
    func extend()

}


extension ThemeProtocol {
    func apply(for application: UIApplication) {
    
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).backgroundColor = Theme.current.secondaryTint
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = Theme.current.secondaryLabelColor
        
        UINavigationBar.appearance().barStyle = Theme.current.barStyle
        UINavigationBar.appearance().tintColor = Theme.current.tint
        UINavigationBar.appearance().largeTitleTextAttributes = [ .foregroundColor: Theme.current.labelColor]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Theme.current.labelColor]

        UITableView.appearance().separatorColor = Theme.current.separatorColor
        UITableView.appearance().backgroundColor = Theme.current.backgroundColor
        UITableViewCell.appearance().backgroundColor = .clear
            
        UITextField.appearance().textColor = Theme.current.labelColor
        UITextView.appearance().textColor = Theme.current.labelColor
        UILabel.appearance().textColor = Theme.current.labelColor
        SecondaryLabel.appearance().textColor = Theme.current.secondaryLabelColor
        
        UITableViewCell.appearance().with {
            $0.backgroundColor = .clear
            $0.selectionColor = selectionColor
        }
        

        self.extend()
        
        UIApplication.shared.windows.reload()

    }
    
    func extend() {
        // Optionally extend theme
    }
}


