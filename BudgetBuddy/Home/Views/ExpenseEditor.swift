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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    saveButton
                }
            }
            .onAppear {
                if let expense {
                    name = expense.name
                    date = expense.date
                    category = expense.category
                    account = expense.account
                    amount = expense.amount
                }
            }
        }
    }
}
#Preview {
    ExpenseEditor(expense: nil)
}

extension ExpenseEditor {
    
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
//            .datePickerStyle(.graphical)
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
            Text("$")
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
                expense.name = name
                expense.category = category
                expense.account = account
                expense.amount = amount ?? 0
                expense.date = date
            } else {
                let item = ExpenseItem(
                    name: name,
                    category: category,
                    account: account,
                    amount: amount ?? 0,
                    date: date
                )
                modelContext.insert(item)
            }
            dismiss()
        }
        .disabled(disableForm)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
        .tint(.bbDanger)
    }
    
}
