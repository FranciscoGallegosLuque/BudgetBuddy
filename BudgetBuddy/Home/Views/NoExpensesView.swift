//
//  NoExpensesView.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 20/09/2025.
//

import SwiftUI

struct NoExpensesView: View {
    var category: Category?

    var body: some View {
        VStack(spacing: Layout.spacing) {
            title
            description
            addExpenseButton
        }
        .padding(Layout.ButtonLayout.externalPadding)
    }
}

#Preview {
    NoExpensesView(category: .culture)
}


extension NoExpensesView {
    
    private var title: some View {
        Text(titleText)
            .font(.title)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
    }
    
    private var titleText: String {
        if let category = self.category {
            "No \(category.displayName.lowercased()) expenses yet!"
        } else {
            "No expenses yet!"
        }
    }
    
    private var description: some View {
        Text(descriptionText)
        .padding(.bottom, Layout.bottomPadding)
        .multilineTextAlignment(.center)
    }
    
    private var descriptionText: String  {
        if let category = self.category {
            "Add your first \(category.displayName.lowercased()) expense below or change the filters applied"
        } else {
            "Add your first expense below"
        }
    }
    
    private var addExpenseButton: some View {
        NavigationLink(
            destination: ExpenseEditor(expense: nil),
            label: {
                Text("Add an expense")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(height: Layout.ButtonLayout.height)
                    .frame(maxWidth: .infinity)
                    .background(.bbPrimary)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: Layout.ButtonLayout.cornerRadius
                        )
                    )
            }
        )
        .padding(.horizontal, Layout.ButtonLayout.internalPadding)
    }
    
}


private enum Layout {
    static let spacing: CGFloat = 10
    static let bottomPadding: CGFloat = 20

    enum ButtonLayout {
        static let height: CGFloat = 55
        static let cornerRadius: CGFloat = 10
        static let internalPadding: CGFloat = 30
        static let externalPadding: CGFloat = 30
    }
}
