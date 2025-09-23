//
//  ExpenseTypeDisplay.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 22/09/2025.
//

import Foundation

extension Category {
    var displayName: String {
        switch self {
        case .food: return "Food"
        case .social: return "Social"
        case .transport: return "Transport"
        case .education: return "Education"
        case .gift: return "Gift"
        case .culture: return "Culture"
        case .household: return "Household"
        }
    }
    
    var displayIcon: String {
        switch self {
        case .food: return "🍝"
        case .social: return "🎊"
        case .transport: return "🚌"
        case .education: return "📚"
        case .gift: return "🎁"
        case .culture: return "🪉"
        case .household: return "🪑"
        }
    }
    
    var displayIconAndName: String {
        "\(self.displayIcon) \(self.displayName)"
    }
}
