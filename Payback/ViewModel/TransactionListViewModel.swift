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
    @Published var bannerData: BannerViewModifier.BannerData? = nil
    
    func fetchTransactions() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in // Mocked delay
            if Bool.random() {
                self?.isLoading = false
                self?.bannerData = BannerViewModifier.BannerData(title: "Error", details: "Some network error", type: .error)
                return
            }
            if let url = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decodedData = try decoder.decode(TransactionList.self, from: jsonData)
                    self?.transactions = decodedData.items
                        .sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate })
                } catch {
                    print(error)
                    self?.bannerData = BannerViewModifier.BannerData(title: "Error", details: error.localizedDescription, type: .error)
                }
            } else {
                self?.bannerData = BannerViewModifier.BannerData(title: "Error", details: "Failed to load JSON data", type: .error)
            }
            
            self?.isLoading = false
        }
    }
}
