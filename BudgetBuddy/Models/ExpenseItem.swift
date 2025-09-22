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
    var typeRaw: String
    var amount: Double
    var date: Date
    
    var type: ExpenseType {
            get { ExpenseType(rawValue: typeRaw) ?? .food }
            set { typeRaw = newValue.rawValue }
        }
    
    init(id: UUID = UUID(), name: String, type: ExpenseType, amount: Double, date: Date = .now) {
        self.id = id
        self.name = name
        self.typeRaw = type.rawValue
        self.amount = amount
        self.date = date
    }
}

enum ExpenseType: String, Codable, CaseIterable {
    case food
    case social
    case transport
    case culture
    case household
    case education
    case gift
}
