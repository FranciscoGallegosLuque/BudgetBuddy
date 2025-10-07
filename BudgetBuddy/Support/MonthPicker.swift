//
//  MonthPicker.swift
//  BudgetBuddy
//
//  Created by Francisco Manuel Gallegos Luque on 06/10/2025.
//

import SwiftUI

struct MonthPicker: View {
    @Binding var selectedMonth: Date

    private var months: [String] {
        DateFormatter().monthSymbols
    }

    private var years: [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array((currentYear - 100)...(currentYear + 100))
    }

    var body: some View {
        VStack {
            Text("This month")
                .fontWeight(.bold)
                .padding(.top, 15)
                .padding(.bottom, 0)
                .onTapGesture {
                withAnimation {
                    selectedMonth = Calendar.current.date(from: Calendar.current.dateComponents(
                        [.year, .month],
                        from: Date.now
                    )) ?? .now
                }
            }
            HStack {
                Picker("Month", selection: monthBinding) {
                    ForEach(0..<months.count, id: \.self) { index in
                        Text(months[index]).tag(index)
                    }
                }
                .pickerStyle(.wheel)

                Picker("Year", selection: yearBinding) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                .pickerStyle(.wheel)
            }
            .frame(height: 200)
            .padding(0)
        }
    }

    // MARK: - Bindings
    private var monthBinding: Binding<Int> {
        Binding(
            get: {
                Calendar.current.component(.month, from: selectedMonth) - 1
            },
            set: { newMonthIndex in
                updateDate(month: newMonthIndex + 1, year: Calendar.current.component(.year, from: selectedMonth))
            }
        )
    }

    private var yearBinding: Binding<Int> {
        Binding(
            get: {
                Calendar.current.component(.year, from: selectedMonth)
            },
            set: { newYear in
                updateDate(month: Calendar.current.component(.month, from: selectedMonth), year: newYear)
            }
        )
    }

    private func updateDate(month: Int, year: Int) {
        if let newDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1)) {
            selectedMonth = newDate
        }
    }
}

#Preview {
    MonthPicker(selectedMonth: .constant(.now))
}
