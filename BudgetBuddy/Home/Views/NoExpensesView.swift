//
//  NoExpensesView.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 20/09/2025.
//

import SwiftUI

struct NoExpensesView: View {
    var expenseType: ExpenseType? = nil

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
    NoExpensesView(expenseType: .culture)
}

private enum Layout {

    static let spacing: CGFloat = 10
    static let bottomPadding: CGFloat = 20

    enum ButtonLayout {
        static let height: CGFloat = 55
        static let cornerRadius: CGFloat = 10
        static let internalPadding: CGFloat = 30
        static let externalPadding: CGFloat = 40
    }
}

extension NoExpensesView {
    
    private var title: some View {
        Text(titleText)
            .font(.title)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
    }
    
    private var titleText: String {
        if let expenseType = self.expenseType {
            "No \(expenseType.displayName.lowercased()) expenses yet!"
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
        if let expenseType = self.expenseType {
            "Add your first \(expenseType.displayName.lowercased()) expense below or change the filters applied"
        } else {
            "Add your first expense below"
        }
    }
    
    private var addExpenseButton: some View {
        NavigationLink(
            destination: AddView(),
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
