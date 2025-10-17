//
//  HomeViewModel.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 07/10/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
final class HomeViewModel {
    private var months: [String] {
        DateFormatter().monthSymbols
    }
    
    func filteredExpensesByMonth(allExpenses: [ExpenseItem], date: Date) -> [Date: [ExpenseItem]] {
        return Dictionary(grouping: allExpenses) { expense in
            let components = Calendar.current.dateComponents(
                [.year, .month],
                from: expense.date
            )
            return Calendar.current.date(from: components) ?? Date()
        }
    }
    
    func expensesInMonth(for month: Date, in allExpenses: [ExpenseItem]) -> [ExpenseItem] {
        filteredExpensesByMonth(allExpenses: allExpenses, date: month)[month] ?? []
    }
    
    func expensesInYear(for year: Date, in allExpenses: [ExpenseItem]) -> [ExpenseItem] {
        filteredExpensesByYear(allExpenses: allExpenses, date: year)[year] ?? []
    }
    
    func filteredExpensesByYear(allExpenses: [ExpenseItem], date: Date) -> [Date: [ExpenseItem]] {
        return Dictionary(grouping: allExpenses) { expense in
            let components = Calendar.current.dateComponents(
                [.year],
                from: expense.date
            )
            return Calendar.current.date(from: components) ?? Date()
        }
    }
}
