//
//  ContentView.swift
//  Currency Converter SwiftUI
//
//  Created by Anton Golovatyuk on 19.12.2024.
//

import SwiftUI

struct CurrencyConverterView: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()
    @State private var showErrorAlert: Bool = false
    
    private let currencies = ["EUR", "USD", "JPY", "GBP", "AUD", "CAD"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                TextField("Enter amount", value: $viewModel.amount, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding(30)
                
                HStack {
                    Picker("From", selection: $viewModel.fromCurrency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    
                    Picker("To", selection: $viewModel.toCurrency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
                Text(viewModel.result)
                    .font(.headline)
                    .padding()
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
            .onAppear {
                viewModel.fetchConversionRate()
                viewModel.startAutoUpdate()
            }
            .onDisappear {
                viewModel.stopAutoUpdate()
            }
            .alert("Error", isPresented: $showErrorAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            })
            .onChange(of: viewModel.errorMessage) { _ in
                showErrorAlert = viewModel.errorMessage != nil
            }
            .navigationTitle("Currency Converter")
            .padding(20)
        }
    }
}


#Preview {
    CurrencyConverterView()
}
