//
//  MonthlyExpensesListViewModel.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 14/10/2025.
//

import Foundation
import SwiftData

final class MonthlyExpensesListViewModel {
    func filteredExpensesByMonth(allExpenses: [ExpenseItem]) -> [Date: [ExpenseItem]] {
        return Dictionary(grouping: allExpenses) { expense in
            let components = Calendar.current.dateComponents(
                [.year, .month],
                from: expense.date
            )
            return Calendar.current.date(from: components) ?? Date()
        }
    }
    
    func monthData(yearExpenses: [ExpenseItem]) -> [MonthData] {
        var monthData: [MonthData] = []
        var filteredExpensesByMonth = filteredExpensesByMonth(allExpenses: yearExpenses)
        var filteredAmountsByMonth = filteredAmountsByMonth(expensesByMonth: filteredExpensesByMonth)
        for (month, amount) in filteredAmountsByMonth {
            monthData.append(MonthData(month: month, totalAmount: amount))
        }
        return monthData
    }
    
    func filteredAmountsByMonth(expensesByMonth: [Date: [ExpenseItem]]) -> [Date: Double] {
        var filteredAmounts: [Date: Double] = [:]
        for month in expensesByMonth.keys {
            filteredAmounts[month] = amountSpendedByMonth(monthExpenses: expensesByMonth[month] ?? [])
        }
        return filteredAmounts
    }
    
    func amountSpendedByMonth(monthExpenses: [ExpenseItem]) -> Double {
        monthExpenses.reduce(0) { partialResult, expense in
            partialResult + expense.amount
        }
    }
    
    func delete(_ offsets: IndexSet, from dayExpenses: [ExpenseItem], in context: ModelContext) {
        for index in offsets {
            context.delete(dayExpenses[index])
        }
        try? context.save()
    }
}
