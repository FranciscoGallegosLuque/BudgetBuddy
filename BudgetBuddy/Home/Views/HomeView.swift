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
    @State private var categoryShowed: Category?
    
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
                    ToolbarItem(placement: .topBarLeading) {
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
        if expenses.isEmpty {
            NoExpensesView()
        } else {
            ExpenseView(
                category: categoryShowed,
                sortOrder: sortOrder
            )
            
      }
    }

    private var expenseButton: some View {
        NavigationLink("+") {
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
