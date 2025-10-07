//
//  ExpenseView.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 20/09/2025.
//

import SwiftData
import SwiftUI

struct DailyExpensesListView: View {
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
    DailyExpensesListView(
        category: nil,
//        sortOrder: [SortDescriptor(\ExpenseItem.name)],
        displayedMonth: Calendar.current.date(from: Calendar.current.dateComponents(
            [.year, .month],
            from: Date.now
        )) ?? .now
    )
    .modelContainer(PreviewSampleData.sampleExpenses())
}

extension DailyExpensesListView {

    init(category: Category?,/* sortOrder: [SortDescriptor<ExpenseItem>],*/ displayedMonth: Date) {
        if let category {
            _expenses = Query(
                filter: #Predicate<ExpenseItem> { expense in
                    expense.categoryRaw == category.rawValue
                }
//                ,sort: sortOrder
            )
        } else {
            _expenses = Query(/*sort: sortOrder*/)
        }

        self.category = category
        self.displayedMonth = displayedMonth
    }

    private var listView: some View {
        List {
            ForEach(sortedGroup, id: \.key) { day, expensesInDay in
                Section(header: dayHeader(for: day)) {
                    ForEach(expensesInDay) { expense in
                        row(for: expense)
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
