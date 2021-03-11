//
//  DateExtension.swift
//  Besedka
//
//  Created by Ivan Kopiev on 06.03.2021.
//

import UIKit

extension Date{
    
    func checkDate() -> String{
        let now = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let dayNow = calendar.component(.day, from: now)
        let monthNow = calendar.component(.month, from: now)
        let year = calendar.component(.year, from: self)
        let yearNow = calendar.component(.year, from: now)
        let dateFormatter = DateFormatter()
        
        if month < monthNow || month == monthNow && day < dayNow || year < yearNow{
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: self)
        }else {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        }
    }
    
}
