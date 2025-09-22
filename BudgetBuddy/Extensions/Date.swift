//
//  Date.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 21/09/2025.
//

import Foundation

extension Date {
    var shortMonthDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM \n d"
        return formatter.string(from: self)
    }
}
