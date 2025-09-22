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
    var expenseType: String

    var body: some View {
        conditionalView
    }

    init(expenseType: String, sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(
            filter: #Predicate<ExpenseItem> { expense in
                if expenseType == "" {
                    return true
                } else {
                    return (expense.type == expenseType)
                }
            },
            sort: sortOrder
        )
        self.expenseType = expenseType
    }

    func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
    }
}

#Preview {
    ExpenseView(
        expenseType: "Personal",
        sortOrder: [SortDescriptor(\ExpenseItem.name)]
    )
    .modelContainer(for: ExpenseItem.self)
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
            ForEach(expenses) { expense in
                HStack {
                    HStack {
                        Text(expense.date.shortMonthDay)
                        Divider ()
                        VStack(alignment: .leading) {
                            Text(expense.name)
                                .font(.headline)
                            Text(expense.type)
                        }
                    }
                    Spacer()
                    Text(
                        expense.amount,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD"
                        )
                    )
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(expense.name), costs \(expense.amount)")
                .accessibilityHint(expense.type)
            }
            .onDelete(perform: removeItems)
        }
    }
    
}
