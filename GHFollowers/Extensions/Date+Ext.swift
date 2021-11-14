//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/4/20.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
