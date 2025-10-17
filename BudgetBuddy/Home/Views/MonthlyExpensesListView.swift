//
//  ExpenseView.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 20/09/2025.
//

import SwiftData
import SwiftUI

struct MonthData: Hashable {
    var displayedMonth: String
    let totalAmount: Double
}

struct MonthlyExpensesListView: View {
    @Environment(\.modelContext) private var modelContext
    private let viewModel: MonthlyExpensesListViewModel = MonthlyExpensesListViewModel()
    
    let yearExpenses: [ExpenseItem]
    
    private var displayedMonths: [MonthData] {
        viewModel.displayedMonthData(from: yearExpenses)
    }
    
    private var months: [String] {
        DateFormatter().monthSymbols
    }

    var body: some View {
        listView
    }
}

#Preview {
    MonthlyExpensesListView(yearExpenses: ExpenseItem.mockExpenses)
}

extension MonthlyExpensesListView {
    private var listView: some View {
        List {
            ForEach(displayedMonths, id: \.self) { data in
                HStack {
                    Text(data.displayedMonth)
                        .font(.title3).fontWeight(.bold)
                    Spacer()
                    amountText(for: data.totalAmount)
                }
                
            }
        }
        .listStyle(.plain)
    }

//    private func rowContent(for expense: ExpenseItem) -> some View {
//        HStack(alignment: .firstTextBaseline) {
//            expenseDetailsText(for: expense)
//            Spacer()
//            amountText(for: expense)
//        }
//    }

    private func dateText(for expense: ExpenseItem) -> some View {
        Text(expense.date.shortMonthDayTwoLines)
    }

    private func expenseDetailsText(for expense: ExpenseItem) -> some View {

        HStack(alignment: .firstTextBaseline) {
            Text(expense.category.displayIcon)
            Text(expense.name)
                .font(.title3).fontWeight(.bold)
            Text(expense.account.rawValue.capitalized).font(.caption2)
                .fontWeight(.light)

        }
    }

    private func amountText(for amount: Double) -> some View {
        HStack(alignment: .bottom) {
            Text(
                amount,
                format: .currency(
                    code: Locale.current.currency?.identifier
                        ?? "USD"
                )
            )
            .font(.headline)
        }
    }

}
