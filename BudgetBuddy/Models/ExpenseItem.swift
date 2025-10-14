//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Francisco Manuel Gallegos Luque on 19/02/2025.
//

import Foundation
import SwiftData

@Model
class ExpenseItem: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var categoryRaw: String
    var accountRaw: String
    var amount: Double
    var date: Date
    
    var category: Category {
            get { Category(rawValue: categoryRaw) ?? .food }
            set { categoryRaw = newValue.rawValue }
        }
    
    var account: Account {
        get { Account(rawValue: accountRaw) ?? .cash }
        set { accountRaw = newValue.rawValue }
    }
    
    init(id: UUID = UUID(), name: String, category: Category, account: Account, amount: Double, date: Date) {
        self.id = id
        self.name = name
        self.categoryRaw = category.rawValue
        self.accountRaw = account.rawValue
        self.amount = amount
        self.date = date
    }
}

enum Category: String, Codable, CaseIterable {
    case food
    case social
    case transport
    case culture
    case household
    case education
    case gift
}

enum Account: String, Codable, CaseIterable {
    case cash
    case credit
    case debit
}

extension ExpenseItem {
    static let mockExpenses = [
        ExpenseItem(
            name: "Coffee",
            category: .food,
            account: .cash,
            amount: 3.50,
            date: .now
        ),
        ExpenseItem(
            name: "Concert Ticket",
            category: .culture,
            account: .cash,
            amount: 50,
            date: .now
        ),
        ExpenseItem(
            name: "Taxi",
            category: .transport,
            account: .credit,
            amount: 12,
            date: .now
        ),
        ExpenseItem(
            name: "Bus",
            category: .transport,
            account: .debit,
            amount: 12,
            date: Date.from(year: 2025, month: 9, day: 19) ?? .now
        ),
        ExpenseItem(
            name: "Bus",
            category: .transport,
            account: .cash,
            amount: 12,
            date: Date.from(year: 2025, month: 9, day: 20) ?? .now
        ),
    ]
}
