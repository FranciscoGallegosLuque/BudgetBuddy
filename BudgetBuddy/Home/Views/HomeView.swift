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
    @Query var expenses: [ExpenseItem]
    @State private var expenseTypeShowed = ""
    
    private var noExpensesAdded: Bool { expenses.isEmpty }

    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.date, order: .reverse),
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
        
    ]

    var body: some View {
        NavigationStack {
            conditionalView
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        if !noExpensesAdded {
                            filterButton
                            sortButton
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        if !noExpensesAdded {
                            expenseButton
                        }
                    }
                }
                .navigationTitle("BudgetBuddy")
        }
    }
}

#Preview {
    HomeView()
}

extension HomeView {

    @ViewBuilder
    private var conditionalView: some View {
        if expenses.isEmpty {
            NoExpensesView()
        } else {
            ExpenseView(
                expenseType: expenseTypeShowed,
                sortOrder: sortOrder
            )
      }
    }

    private var expenseButton: some View {
        NavigationLink("+") {
            AddView()
        }
        .font(.title)
    }

    private var filterButton: some View {
        Menu(
            "",
            systemImage:
                "slider.horizontal.3"
        ) {
            Picker("Filter", selection: $expenseTypeShowed) {
                Text("Show only Personal expenses")
                    .tag("Personal")

                Text("Show only Business expenses")
                    .tag("Business")

                Text("Remove filters")
                    .tag("")
            }
        }
    }

    private var sortButton: some View {
        Menu("", systemImage: "arrow.up.arrow.down") {
            Picker("Sort", selection: $sortOrder) {
                Text("Sort by Name")
                    .tag([
                        SortDescriptor(\ExpenseItem.name),
                        SortDescriptor(\ExpenseItem.amount),
                        SortDescriptor(\ExpenseItem.date)
                    ])

                Text("Sort by Amount")
                    .tag([
                        SortDescriptor(\ExpenseItem.amount),
                        SortDescriptor(\ExpenseItem.name),
                        SortDescriptor(\ExpenseItem.date),

                        
                    ])
                Text("Sort by Date")
                    .tag([
                        SortDescriptor(\ExpenseItem.date, order: .reverse),
                        SortDescriptor(\ExpenseItem.amount),
                        SortDescriptor(\ExpenseItem.name),
                    ])
            }
        }
    }

}
