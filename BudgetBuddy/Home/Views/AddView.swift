//
//  AddView.swift
//  iExpense
//
//  Created by Francisco Manuel Gallegos Luque on 27/01/2025.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var expenses: [ExpenseItem]
    
    private var disableForm: Bool { name.isEmpty || amount == nil }

    @State private var name = ""
    @State private var date: Date = .now
    @State private var type: ExpenseType = .food
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
            .navigationTitle("Add Expense")
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    saveButton
                }
                ToolbarItem(placement: .topBarLeading) {
                    cancelButton
                }
            }
        }
    }
}
#Preview {
    AddView()
}

extension AddView {
    
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
        Picker("Category", selection: $type) {
            ForEach(ExpenseType.allCases, id: \.self) { type in
                Text(type.displayIcon + " " + type.displayName).tag(type)
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
            let item = ExpenseItem(
                name: name,
                type: type,
                account: account,
                amount: amount ?? 0,
                date: date
            )
            modelContext.insert(item)
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
