//
//  MonthlyExpensesListViewModel.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 14/10/2025.
//

import Foundation
import SwiftData

final class MonthlyExpensesListViewModel {
    func displayedMonthData(from yearExpenses: [ExpenseItem]) -> [MonthData] {
        let months = Calendar.current.monthSymbols
        var monthData: [MonthData] = []
        let filteredExpensesByMonth = filteredExpensesByMonth(allExpenses: yearExpenses)
        for month in months {
            if filteredExpensesByMonth.contains(where: { key, value in
                key == month
            }) {
                monthData.append(MonthData(displayedMonth: month, totalAmount: monthTotalAmount(monthExpenses: filteredExpensesByMonth[month] ?? [])))
            } else {
                monthData.append(MonthData(displayedMonth: month, totalAmount: 0))
            }
        }
        return monthData
    }
    
    func filteredExpensesByMonth(allExpenses: [ExpenseItem]) -> [String: [ExpenseItem]] {
        return Dictionary(grouping: allExpenses) { expense in
            let components = Calendar.current.dateComponents(
                [.year, .month],
                from: expense.date
            )
            return Calendar.current.date(from: components)?.month ?? "January"
        }
    }
    
    func monthTotalAmount(monthExpenses: [ExpenseItem]) -> Double {
        return monthExpenses.reduce(0) { partialResult, expense in
            partialResult + expense.amount
        }
    }
}
