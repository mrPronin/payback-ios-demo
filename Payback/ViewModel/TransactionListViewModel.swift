//
//  TransactionListViewModel.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import Foundation
import Network

@MainActor
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
    
    var filteredTransactionsTotal: Double {
        return filteredTransactions.reduce(0.0) { $0 + $1.transactionDetail.value.amount }
    }
    
    func fetchTransactions() async {
        
        guard isNetworkAvailable else { return }
        
        isLoading = true
        
        if /*Bool.random()*/ false {
            isLoading = false
            bannerData = BannerViewModifier.BannerData(title: "Error", details: "Some network error", type: .error)
            return
        }
        if let url = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") {
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate a 1 second
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedData = try decoder.decode(TransactionList.self, from: data)
                let transactions = decodedData.items
                    .sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate })
                self.transactions = transactions
                let categories = Array(Set(transactions.map { $0.category })).sorted()
                categoryFilterPickerOptions = [(-1, "All")]
                categoryFilterPickerOptions.append(contentsOf: categories.map { (id: $0, title: "Category \($0)") })
            } catch {
                print(error)
                bannerData = BannerViewModifier.BannerData(title: "Error", details: error.localizedDescription, type: .error)
            }
        } else {
            bannerData = BannerViewModifier.BannerData(title: "Error", details: "Failed to load JSON data", type: .error)
        }
        
        isLoading = false
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
