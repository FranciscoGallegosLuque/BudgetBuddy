//
//  DailyExpensesListViewModel.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 14/10/2025.
//

import Foundation
import SwiftData

@Observable
final class DailyExpensesListViewModel {
    func filteredExpensesByDay(allExpenses: [ExpenseItem]) -> [Date: [ExpenseItem]] {
        return Dictionary(grouping: allExpenses) { expense in
            Calendar.current.startOfDay(for: expense.date)
        }
    }
    
    func delete(_ offsets: IndexSet, from dayExpenses: [ExpenseItem], in context: ModelContext) {
        for index in offsets {
            context.delete(dayExpenses[index])
        }
        
        try? context.save()
    }
}
