//
//  TransactionListViewModel.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import Foundation
import Network

class TransactionListViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var bannerData: BannerViewModifier.BannerData? = nil
    @Published var categoryFilterPickerOptions: [(id: Int, title: String)] = []
    @Published var selectedCategoryFilter: Int = -1 {
        didSet {
            objectWillChange.send()
        }
    }
    
    var filteredTransactions: [Transaction] {
        guard selectedCategoryFilter != -1 else {
            return transactions
        }
        return transactions.filter { $0.category == selectedCategoryFilter }
    }
    
    func fetchTransactions() {
        
        guard isNetworkAvailable else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in // Mocked delay
            if /*Bool.random()*/ false {
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
                    let transactions = decodedData.items
                        .sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate })
                    self?.transactions = transactions
                    let categories = Array(Set(transactions.map { $0.category })).sorted()
                    self?.categoryFilterPickerOptions = [(-1, "All")]
                    self?.categoryFilterPickerOptions.append(contentsOf: categories.map { (id: $0, title: "Category \($0)") })
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
    
    // MARK: - Init

    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let isNetworkAvailable = path.status == .satisfied
                self?.isNetworkAvailable = isNetworkAvailable
                if !isNetworkAvailable {
                    self?.bannerData = BannerViewModifier.BannerData(title: "Error", details: "Network is not available", type: .error)
                } else {
                    self?.bannerData = nil
                }
            }
        }
        monitor.start(queue: queue)
    }

    // MARK: - Private
    
    private var isNetworkAvailable = true
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var transactions = [Transaction]()
}
