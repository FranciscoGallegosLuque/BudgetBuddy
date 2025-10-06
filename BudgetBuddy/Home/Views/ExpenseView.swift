//
//  ExpenseView.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 20/09/2025.
//

import SwiftData
import SwiftUI

struct ExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    var category: Category?
    var expensesGroupedByDay: [Date: [ExpenseItem]] {
        Dictionary(grouping: expenses) { expense in
            Calendar.current.startOfDay(for: expense.date)
        }
    }

    var sortedGroup: [(key: Date, value: [ExpenseItem])] {
        expensesGroupedByDay.sorted { $0.key > $1.key }
    }

    var body: some View {
        if expenses.isEmpty {
            NoExpensesView(category: category)
        } else {
            listView
        }
    }
}

#Preview {
    ExpenseView(
        category: nil,
        sortOrder: [SortDescriptor(\ExpenseItem.name)]
    )
    .modelContainer(PreviewSampleData.sampleExpenses())
}

extension ExpenseView {

    init(category: Category?, sortOrder: [SortDescriptor<ExpenseItem>]) {
        if let category {
            _expenses = Query(
                filter: #Predicate<ExpenseItem> { expense in
                    expense.categoryRaw == category.rawValue
                },
                sort: sortOrder
            )
        } else {
            _expenses = Query(
                sort: sortOrder
            )
        }

        self.category = category
    }

    private var listView: some View {
        List {
            ForEach(sortedGroup, id: \.key) { day, expensesInDay in
                Section(header: Text(day.dayMonthYear)) {
                    ForEach(expensesInDay) { expense in
                        NavigationLink {
                            ExpenseEditor(expense: expense)
                        } label: {
                            rowContent(for: expense)
                        }
                        
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(
                            "\(expense.name), costs \(expense.amount)"
                        )
                        .accessibilityHint(expense.category.displayName)
                           
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let expenseToDelete = expensesInDay[index]
                            withAnimation {
                                modelContext.delete(expenseToDelete)
                            }
                        }
                    }
                }
            }
        }
    }

    private func rowContent(for expense: ExpenseItem) -> some View {
        HStack {
            expenseDetailsText(for: expense)
            Spacer()
            amountText(for: expense)
        }
    }

    private func dateText(for expense: ExpenseItem) -> some View {
        Text(expense.date.shortMonthDayTwoLines)
    }

    private func expenseDetailsText(for expense: ExpenseItem) -> some View {
        VStack(alignment: .leading) {
            Text(expense.name)
                .font(.headline)
            Text(expense.category.displayIconAndName)
                .font(.subheadline)
        }
    }

    private func amountText(for expense: ExpenseItem) -> some View {
        VStack(alignment: .trailing) {
            Text(
                expense.amount,
                format: .currency(
                    code: Locale.current.currency?.identifier
                    ?? "USD"
                )
            )
            .font(.headline)
            Text(expense.account.rawValue.capitalized).font(.subheadline)
        }
    }

}
