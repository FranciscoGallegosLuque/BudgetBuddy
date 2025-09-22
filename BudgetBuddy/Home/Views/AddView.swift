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
    @State private var type = "Personal"
    @State private var amount: Double? = nil

    let types = ["Business", "Personal"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense name") {
                    TextField("Add expense name", text: $name)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                Section("Expense details") {
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
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

            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        let item = ExpenseItem(
                            name: name,
                            type: type,
                            amount: amount ?? 0
                        )
                        modelContext.insert(item)
                        dismiss()
                    }
                    .disabled(disableForm)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }

            }
            .navigationBarBackButtonHidden()

        }
    }
}
#Preview {
    AddView()
}
