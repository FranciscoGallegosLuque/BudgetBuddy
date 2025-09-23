//
//  PreviewSampleData.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 22/09/2025.
//

import Foundation
import SwiftData

@MainActor
struct PreviewSampleData {
    static func sampleExpenses() -> ModelContainer {
        do {
            let container = try ModelContainer(
                for: ExpenseItem.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            let mockExpenses = [
                ExpenseItem(
                    name: "Coffee",
                    category: .food,
                    account: .cash,
                    amount: 3.50,
                    date: .now
                ),
                ExpenseItem(
                    name: "Concert Ticket",
                    category: .culture,
                    account: .cash,
                    amount: 50,
                    date: .now
                ),
                ExpenseItem(
                    name: "Taxi",
                    category: .transport,
                    account: .credit,
                    amount: 12,
                    date: .now
                ),
                ExpenseItem(
                    name: "Bus",
                    category: .transport,
                    account: .debit,
                    amount: 12,
                    date: Date.from(year: 2025, month: 9, day: 19) ?? .now
                ),
                ExpenseItem(
                    name: "Bus",
                    category: .transport,
                    account: .cash,
                    amount: 12,
                    date: Date.from(year: 2025, month: 9, day: 20) ?? .now
                ),
            ]

            for mockExpense in mockExpenses {
                container.mainContext.insert(mockExpense)
            }

            return container
        } catch {
            fatalError("Failed to create container")
        }
    }
}
