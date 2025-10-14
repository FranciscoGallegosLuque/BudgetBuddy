//
//  ExpenseView.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 20/09/2025.
//

import SwiftData
import SwiftUI

struct DailyExpensesListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DailyExpensesListViewModel()

    let expenses: [ExpenseItem]

    var sortedGroup: [(key: Date, value: [ExpenseItem])] {
        viewModel.filteredExpensesByDay(allExpenses: expenses).sorted { $0.key > $1.key }
    }

    var body: some View {
        if expenses.isEmpty {
            NoExpensesView()
        } else {
            listView
        }
    }
}

#Preview {
    DailyExpensesListView(expenses: ExpenseItem.mockExpenses)
}

extension DailyExpensesListView {
    private var listView: some View {
        List {
            ForEach(sortedGroup, id: \.key) { day, expensesInDay in
                Section(header: dayHeader(for: day)) {
                    ForEach(expensesInDay) { expense in
                        row(for: expense)
                    }
                    .onDelete { indexSet in
                        viewModel.delete(indexSet, from: expensesInDay, in: modelContext)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private func dayHeader(for day: Date) -> some View {
        HStack(alignment: .center) {
            Text(day.day).bold()
            Text(day.weekDay).font(.footnote)
        }
    }
    
    private func row(for expense: ExpenseItem) -> some View {
        ZStack(alignment: .leading) {
            NavigationLink {
                ExpenseEditor(expense: expense)
            } label: {
                EmptyView()
                    .opacity(Layout.Row.opacity)
            }
            rowContent(for: expense)
        }
    }

    private func rowContent(for expense: ExpenseItem) -> some View {
        HStack(alignment: .firstTextBaseline) {
            expenseDetailsText(for: expense)
            Spacer()
            amountText(for: expense)
        }
        .padding(.vertical, Layout.Row.contentPadding)
    }

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

    private func amountText(for expense: ExpenseItem) -> some View {
        HStack(alignment: .bottom) {
            Text(
                expense.amount,
                format: .currency(
                    code: Locale.current.currency?.identifier
                        ?? "USD"
                )
            )
            .font(.headline)
        }
    }
}

private enum Layout {
    enum Row {
        static let opacity: CGFloat = 0
        static let contentPadding: CGFloat = 4
    }
}
