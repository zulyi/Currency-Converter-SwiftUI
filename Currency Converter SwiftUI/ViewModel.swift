//
//  ViewModel.swift
//  Currency Converter SwiftUI
//
//  Created by Anton Golovatyuk on 19.12.2024.
//

import Foundation
import Alamofire

class CurrencyConverterViewModel: ObservableObject {
    @Published var result: String = "Converted Amount"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let baseURL = "http://api.evp.lt/currency/commercial/exchange"
    @Published var fromCurrency: String = "EUR"
    @Published var toCurrency: String = "USD"
    @Published var amount: Double = 1.0
    
    private var updateTimer: Timer?
    
    func fetchConversionRate() {
        isLoading = true
        let url = "\(baseURL)/\(amount)-\(fromCurrency)/\(toCurrency)/latest"
        
        AF.request(url).responseJSON { [weak self] response in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
            switch response.result {
            case .success(let json):
                if let dict = json as? [String: Any], let result = dict["amount"] as? String {
                    DispatchQueue.main.async {
                        self?.result = "Result: \(result) \(self?.toCurrency ?? "")"
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Invalid response format."
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to fetch conversion rate: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func startAutoUpdate() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.fetchConversionRate()
        }
    }
    
    func stopAutoUpdate() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
}

