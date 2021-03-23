//
//  UITableViewCell.swift
//  Besedka
//
//  Created by Ivan Kopiev on 11.03.2021.
//

import UIKit

public extension UITableViewCell {

    /// The color of the cell when it is selected.
    @objc dynamic var selectionColor: UIColor? {
        get { return selectedBackgroundView?.backgroundColor }
        set {
            guard selectionStyle != .none else { return }

            selectedBackgroundView = UIView().with {
                $0.backgroundColor = newValue
            }
        }
    }
}
