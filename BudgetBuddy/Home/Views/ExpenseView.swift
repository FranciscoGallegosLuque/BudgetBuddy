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
    var displayedMonth: Date
    
    var expensesGroupedByMonth: [Date: [ExpenseItem]] {
        Dictionary(grouping: expenses) { expense in
            let components = Calendar.current.dateComponents(
                [.year, .month],
                from: expense.date
            )
            return Calendar.current.date(from: components)!
        }
    }
    
    var monthExpenses: [ExpenseItem] {
        expensesGroupedByMonth[displayedMonth] ?? []
    }

    var expensesGroupedByDay: [Date: [ExpenseItem]] {
        Dictionary(grouping: monthExpenses) { expense in
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
        sortOrder: [SortDescriptor(\ExpenseItem.name)],
        displayedMonth: Calendar.current.date(from: Calendar.current.dateComponents(
            [.year, .month],
            from: Date.now
        )) ?? .now
    )
    .modelContainer(PreviewSampleData.sampleExpenses())
}

extension ExpenseView {

    init(category: Category?, sortOrder: [SortDescriptor<ExpenseItem>], displayedMonth: Date) {
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
        self.displayedMonth = displayedMonth
    }

    private var listView: some View {
        List {
            ForEach(sortedGroup, id: \.key) { day, expensesInDay in
                Section(
                    header: HStack(alignment: .center) {
                        Text(day.day).bold()
                        Text(day.weekDay).font(.footnote)
                    }
                ) {
                    ForEach(expensesInDay) { expense in
                        ZStack(alignment: .leading) {
                            NavigationLink {
                                ExpenseEditor(expense: expense)
                            } label: {
                                EmptyView()
                                    .opacity(0)
                            }
                            rowContent(for: expense)
                                .padding(.vertical, 4)
                        }

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
        .listStyle(.plain)
    }

    private func rowContent(for expense: ExpenseItem) -> some View {
        HStack(alignment: .firstTextBaseline) {
            expenseDetailsText(for: expense)
            Spacer()
            amountText(for: expense)
        }
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
