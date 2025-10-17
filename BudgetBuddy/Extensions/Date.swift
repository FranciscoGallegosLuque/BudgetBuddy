//
//  Date.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 21/09/2025.
//

import Foundation

extension Date {
    var shortMonthDayTwoLines: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM \n d"
        return formatter.string(from: self)
    }
    
    var dayMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: self)
    }
    
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    var monthNumber: String {
        return self.formatted(Date.FormatStyle().month(.defaultDigits))
    }
    
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: self)
    }
    
    var weekDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    var monthAndYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
    
/// Create a date from specified parameters
    ///
    /// - Parameters:
    ///   - year: The desired year
    ///   - month: The desired month
    ///   - day: The desired day
    /// - Returns: A `Date` object
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil
    }
    
    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) ?? .now
    }
    
    var startOfYear: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year], from: self)) ?? .now
    }
    
    static var startOfCurrentMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? .now
    }
    
    static var startOfCurrentYear: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Date())) ?? .now
    }
}
