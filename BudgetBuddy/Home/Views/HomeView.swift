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
    @State private var expenseTypeShowed: ExpenseType?
    
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.date, order: .reverse),
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
        
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                conditionalView
            }
                .safeAreaInset(edge: .top, spacing: 0) {
                    Color.clear.frame(height: 25)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        if !expenses.isEmpty {
                            filterButton
//                            sortButton
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        if !expenses.isEmpty {
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
        .modelContainer(PreviewSampleData.sampleExpenses())
}

extension HomeView {

    @ViewBuilder
    private var conditionalView: some View {
        if noExpensesAdded {
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
                Text("Food expenses")
                    .tag(ExpenseType.food as ExpenseType?)

                Text("Social expenses")
                    .tag(ExpenseType.social as ExpenseType?)
                
                Text("Transport expenses")
                    .tag(ExpenseType.transport as ExpenseType?)

                Text("Culture expenses")
                    .tag(ExpenseType.culture as ExpenseType?)
                
                Text("Household expenses")
                    .tag(ExpenseType.household as ExpenseType?)

                Text("Education expenses")
                    .tag(ExpenseType.education as ExpenseType?)
                
                Text("Gift expenses")
                    .tag(ExpenseType.gift as ExpenseType?)

                Text("Remove filters")
                    .tag(nil as ExpenseType?)
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
