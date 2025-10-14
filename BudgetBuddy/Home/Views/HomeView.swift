//
//  HomeView.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 18/09/2025.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @State private var viewModel = HomeViewModel()
    
    @Query var expenses: [ExpenseItem]
    
    @State private var categoryShowed: Category?
    @State private var expensesTimeSpam: TimeSpam = .daily
    
    @State private var displayedMonth: Date = .startOfCurrentMonth
    @State private var showCalendar = false

    var body: some View {
        NavigationStack {
            VStack {
                timeSpanPicker
                monthSelector
                expensesContent
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { if !expenses.isEmpty { filterButton } }
                ToolbarItem(placement: .topBarTrailing) { if !expenses.isEmpty { addExpenseButton } }
            }
            .navigationTitle("Budget Buddy")
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(PreviewSampleData.sampleExpenses())
}

extension HomeView {

    @ViewBuilder
    private var expensesContent: some View {
        if expenses.isEmpty {
            NoExpensesView()
        } else if expensesTimeSpam == .daily {
            DailyExpensesListView(
                expenses: viewModel.filteredExpensesByMonth(allExpenses: expenses, date: displayedMonth)[displayedMonth] ?? []
            )
        } else {
            VStack {
                NoExpensesView()
            }
            .frame(maxHeight: .infinity)
        }
    }

    private var addExpenseButton: some View {
        NavigationLink(Layout.AddExpenseButton.icon) {
            ExpenseEditor(expense: nil)
        }
        .font(.title)
    }

    private var filterButton: some View {
        Menu(
            "",
            systemImage:
                "slider.horizontal.3"
        ) {
            Picker("Filter", selection: $categoryShowed) {
                Text("All expenses").tag(nil as Category?)
                Text("Food expenses").tag(Category.food as Category?)
                Text("Social expenses").tag(Category.social as Category?)
                Text("Transport expenses").tag(Category.transport as Category?)
                Text("Culture expenses").tag(Category.culture as Category?)
                Text("Household expenses").tag(Category.household as Category?)
                Text("Education expenses").tag(Category.education as Category?)
                Text("Gift expenses").tag(Category.gift as Category?)
            }
        }
    }
    
    @ViewBuilder
    private var monthSelector: some View {
        Divider()
        HStack {
            Image(systemName: Layout.MonthSelection.leftIcon).onTapGesture { changeMonth(ascending: false) }
            Spacer()
            Button(displayedMonth.monthAndYear) {
                showCalendar.toggle()
            }
            .popover(isPresented: $showCalendar) {
                MonthPicker(selectedMonth: $displayedMonth).presentationCompactAdaptation(.popover)
            }
            Spacer()
            Image(systemName: Layout.MonthSelection.rightIcon).onTapGesture { changeMonth(ascending: true) }
        }
        .padding(Layout.MonthSelection.padding)
        Divider()
    }
    
    private var timeSpanPicker: some View {
        Picker("", selection: $expensesTimeSpam) {
            Text(TimeSpam.daily.rawValue.capitalized).tag(TimeSpam.daily)
            Text(TimeSpam.monthly.rawValue.capitalized).tag(TimeSpam.monthly)
        }
        .pickerStyle(.segmented)
        .padding()
    }

    //    private var sortButton: some View {
    //        Menu("", systemImage: "arrow.up.arrow.down") {
    //            Picker("Sort", selection: $sortOrder) {
    //                Text("Sort by Name")
    //                    .tag([
    //                        SortDescriptor(\ExpenseItem.name),
    //                        SortDescriptor(\ExpenseItem.amount),
    //                        SortDescriptor(\ExpenseItem.date)
    //                    ])
    //
    //                Text("Sort by Amount")
    //                    .tag([
    //                        SortDescriptor(\ExpenseItem.amount),
    //                        SortDescriptor(\ExpenseItem.name),
    //                        SortDescriptor(\ExpenseItem.date),
    //
    //
    //                    ])
    //                Text("Sort by Date")
    //                    .tag([
    //                        SortDescriptor(\ExpenseItem.date, order: .reverse),
    //                        SortDescriptor(\ExpenseItem.amount),
    //                        SortDescriptor(\ExpenseItem.name),
    //                    ])
    //            }
    //        }
    //    }

    private func changeMonth(ascending: Bool) {
        let amount = 1
        var components = Calendar.current.dateComponents(
            [.year, .month],
            from: displayedMonth
        )
        components.month = (components.month ?? 1) + (ascending ? amount : -amount)
        let newDate = Calendar.current.date(from: components) ?? .now
        displayedMonth = newDate
    }
}

private enum Layout {
    enum AddExpenseButton {
        static let icon: String = "+"
    }
    
    enum MonthSelection {
        static let leftIcon: String = "chevron.left"
        static let rightIcon: String = "chevron.right"
        static let padding: CGFloat = 10
    }
}

private enum TimeSpam: String {
    case daily
    case monthly
}
