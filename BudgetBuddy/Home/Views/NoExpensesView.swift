//
//  NoExpensesView.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 20/09/2025.
//

import SwiftUI

struct NoExpensesView: View {
    var expenseType: String = ""

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
    NoExpensesView()
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
        Text(
            expenseType.isEmpty
                ? "No expenses yet!"
                : "No \(expenseType.lowercased()) expenses yet!"
        )
        .font(.title)
        .fontWeight(.semibold)
        .multilineTextAlignment(.center)
    }
    
    private var description: some View {
        Text(
            expenseType.isEmpty
                ? "Add your first expense below"
                : "Add your first \(expenseType.lowercased()) expense below"
        )
        .padding(.bottom, Layout.bottomPadding)
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
