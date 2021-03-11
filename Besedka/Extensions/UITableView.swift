//
//  UITableViewExtension.swift
//  Besedka
//
//  Created by Ivan Kopiev on 06.03.2021.
//

import UIKit

//MARK: - Extensions TableView

extension UITableView {
    func setOffsetToBottom(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: true)
    }

    func scrollToLastRow(animated: Bool) {
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0) as IndexPath, at: .bottom, animated: animated)
        }
    }
    
}


