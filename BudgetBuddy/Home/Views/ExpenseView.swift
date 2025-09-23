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
    var expenseType: ExpenseType? = nil

    var expensesGroupedByDay: [Date: [ExpenseItem]] {
        Dictionary(grouping: expenses) { expense in
            Calendar.current.startOfDay(for: expense.date)
        }
    }

    var sortedGroup: [(key: Date, value: [ExpenseItem])] {
        expensesGroupedByDay.sorted { $0.key > $1.key }
    }

    var body: some View {
        conditionalView
    }

    init(expenseType: ExpenseType?, sortOrder: [SortDescriptor<ExpenseItem>]) {
        if let expenseType {
            _expenses = Query(
                filter: #Predicate<ExpenseItem> { expense in
                    expense.typeRaw == expenseType.rawValue
                },
                sort: sortOrder
            )
        } else {
            _expenses = Query(
                sort: sortOrder
            )
        }
    }
}

#Preview {
    ExpenseView(
        expenseType: nil,
        sortOrder: [SortDescriptor(\ExpenseItem.name)]
    )
    .modelContainer(PreviewSampleData.sampleExpenses())
}

extension ExpenseView {

    @ViewBuilder
    private var conditionalView: some View {
        if expenses.isEmpty {
            NoExpensesView(expenseType: expenseType)
        } else {
            listView

        }
    }

    private var listView: some View {
        List {
            ForEach(sortedGroup, id: \.key) { day, expensesInDay in
                Section(header: Text(day.dayMonthYear)) {
                    ForEach(expensesInDay) { expense in
                        HStack {
                            HStack {
                                Text(expense.date.shortMonthDay)
                                Divider()
                                VStack(alignment: .leading) {
                                    Text(expense.name)
                                        .font(.headline)
                                    HStack {
                                        Text(expense.type.displayIcon)
                                        Text(expense.type.displayName)
                                    }
                                }
                            }
                            Spacer()
                            Text(
                                expense.amount,
                                format: .currency(
                                    code: Locale.current.currency?.identifier
                                        ?? "USD"
                                )
                            )
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(
                            "\(expense.name), costs \(expense.amount)"
                        )
                        .accessibilityHint(expense.type.displayName)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let expenseToDelete = expensesInDay[index]
                            modelContext.delete(expenseToDelete)
                        }
                    }
                }
            }
        }
    }

}
