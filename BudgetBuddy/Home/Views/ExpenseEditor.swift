//
//  AddView.swift
//  iExpense
//
//  Created by Francisco Manuel Gallegos Luque on 27/01/2025.
//

import SwiftUI
import SwiftData

struct ExpenseEditor: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var expenses: [ExpenseItem]
    
    private var disableForm: Bool { name.isEmpty || amount == nil }

    let expense: ExpenseItem?
    
    @State private var name = ""
    @State private var date: Date = .now
    @State private var category: Category = .food
    @State private var account: Account = .cash
    @State private var amount: Double? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense name") {
                    expenseNameField
                }
                Section("Expense details") {
                    dateField
                    categoryField
                    accountField
                    amountField
                }
            }
            .navigationTitle(expense == nil ? "Add Expense" : "Edit Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { saveButton } }
            .onAppear { if let expense { loadCurrentExpenseValues(for: expense) } }
        }
    }
}
#Preview {
    ExpenseEditor(expense: nil)
}

extension ExpenseEditor {
    
    private func loadCurrentExpenseValues(for expense: ExpenseItem) {
        name = expense.name
        date = expense.date
        category = expense.category
        account = expense.account
        amount = expense.amount
    }
    
    private var expenseNameField: some View {
        TextField("Add expense name", text: $name)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
    
    private var dateField: some View {
        DatePicker(
                "Date",
                selection: $date,
                displayedComponents: [.date]
            )
    }

    
    private var categoryField: some View {
        Picker("Category", selection: $category) {
            ForEach(Category.allCases, id: \.self) { category in
                Text(category.displayIcon + " " + category.displayName).tag(category)
                }
        }
    }
    
    private var accountField: some View {
        Picker("Account", selection: $account) {
            ForEach(Account.allCases, id: \.self) { account in
                Text(account.rawValue.capitalized).tag(account)
                }
        }
    }
    
    private var amountField: some View {
        HStack {
            Text(Locale.current.currencySymbol ?? "$")
            TextField(
                "0.00",
                value: $amount,
                format: .number
            )
            .keyboardType(.decimalPad)
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            if let expense {
                saveEditedExpense(expense: expense)
            } else {
                saveNewExpense()
            }
            dismiss()
        }
        .disabled(disableForm)
    }
    
    private func saveEditedExpense(expense: ExpenseItem) {
        expense.name = name
        expense.category = category
        expense.account = account
        expense.amount = amount ?? 0
        expense.date = date
    }
    
    private func saveNewExpense() {
        let item = ExpenseItem(
            name: name,
            category: category,
            account: account,
            amount: amount ?? 0,
            date: date
        )
        modelContext.insert(item)
    }
}
