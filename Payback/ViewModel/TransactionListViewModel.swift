//
//  TransactionListViewModel.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import Foundation

class TransactionListViewModel: ObservableObject {
    
    @Published var transactions = [Transaction]()
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func fetchTransactions() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in // Mocked delay
            if let url = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: url)
                    let decodedData = try JSONDecoder().decode(TransactionList.self, from: jsonData)
                    self?.transactions = decodedData.items.sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate })
                } catch {
                    self?.errorMessage = error.localizedDescription
                }
            } else {
                self?.errorMessage = "Failed to load JSON data"
            }
            
            self?.isLoading = false
        }
    }
}
