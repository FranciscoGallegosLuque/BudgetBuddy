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
    private let viewModel = HomeViewModel()
    
    @Query var expenses: [ExpenseItem]
    
    @State private var categoryShowed: Category?
    @State private var expensesTimeSpan: TimeSpan = .daily
    
    @State private var displayedMonth: Date = .startOfCurrentMonth
    @State private var displayedYear: Date = .startOfCurrentYear
    
    @State private var showCalendar = false
    
    private var displayedExpenses: [ExpenseItem] {
        switch expensesTimeSpan {
        case .daily:
            viewModel.expensesInMonth(for: displayedMonth, in: expenses)
        case .monthly:
            viewModel.expensesInYear(for: displayedYear, in: expenses)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                timeSpanPicker
                if expensesTimeSpan == .daily {
                    displayedDateSelector(timeSpan: .daily)
                } else {
                    displayedDateSelector(timeSpan: .monthly)
                }
                expensesContent
                    .frame(maxHeight: .infinity)
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
        } else if expensesTimeSpan == .daily {
            DailyExpensesListView(expenses: displayedExpenses)
        } else {
            MonthlyExpensesListView(yearExpenses: displayedExpenses)
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
    
    private func displayedDateSelector(timeSpan: TimeSpan) -> some View {
        VStack {
            Divider()
            HStack {
                Image(systemName: Layout.DateSelection.leftIcon).onTapGesture { timeSpan == .daily ? changeMonth(ascending: false) : changeYear(ascending: false)}
                Spacer()
                if timeSpan == .daily { displayedMonthText } else { displayedYearText }
                Spacer()
                Image(systemName: Layout.DateSelection.rightIcon).onTapGesture { timeSpan == .daily ? changeMonth(ascending: true) : changeYear(ascending: true)}
            }
            .padding(.horizontal, Layout.DateSelection.paddingHorizontal)
            .padding(.vertical, Layout.DateSelection.paddingVertical)
            Divider()
        }
    }
    
    private var displayedMonthText: some View {
        Button(displayedMonth.monthAndYear) {
            showCalendar.toggle()
        }
        .popover(isPresented: $showCalendar) {
            MonthPicker(selectedMonth: $displayedMonth).presentationCompactAdaptation(.popover)
        }
        .buttonStyle(.plain)
        .bold()
    }
    
    private var displayedYearText: some View {
        Text(displayedYear.year).bold()
    }
    
    private var timeSpanPicker: some View {
        Picker("", selection: $expensesTimeSpan) {
            Text(TimeSpan.daily.rawValue.capitalized).tag(TimeSpan.daily)
            Text(TimeSpan.monthly.rawValue.capitalized).tag(TimeSpan.monthly)
        }
        .pickerStyle(.segmented)
        .padding()
    }

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
    
    private func changeYear(ascending: Bool) {
        let amount = 1
        var components = Calendar.current.dateComponents(
            [.year],
            from: displayedYear
        )
        components.year = (components.year ?? 1) + (ascending ? amount : -amount)
        let newDate = Calendar.current.date(from: components) ?? .now
        displayedYear = newDate
    }
}

private enum Layout {
    enum AddExpenseButton {
        static let icon: String = "+"
    }
    
    enum DateSelection {
        static let leftIcon: String = "chevron.left"
        static let rightIcon: String = "chevron.right"
        static let paddingVertical: CGFloat = 2
        static let paddingHorizontal: CGFloat = 10
    }
}

private enum TimeSpan: String {
    case daily
    case monthly
}
