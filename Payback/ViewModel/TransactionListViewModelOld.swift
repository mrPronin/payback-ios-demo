//
//  TransactionListViewModel.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import Foundation
import Network
import PaybackCommon

final class TransactionListViewModelOld: ObservableObject {
    
    @Published private(set) var isLoading = false
    @Published var bannerData: BannerViewModifier.BannerData? = nil
    @Published private(set) var categoryFilterPickerOptions: [(id: Int, title: String)] = []
    @Published var selectedCategoryFilter: Int = -1 {
        didSet {
            objectWillChange.send()
        }
    }
    
    var filteredTransactions: [TransactionItem] {
        guard selectedCategoryFilter != -1 else {
            return transactions
        }
        return transactions.filter { $0.category == selectedCategoryFilter }
    }
    
    var filteredTransactionsTotal: Double {
        return filteredTransactions.reduce(0.0) { $0 + $1.transactionDetail.value.amount }
    }
    
    var transactionsCurrency: String {
        guard let currency = Array(Set(filteredTransactions.map(\.transactionDetail.value.currency))).first else {
            return ""
        }
        return currency
    }
    
    func fetchTransactions() async {
        
        guard isNetworkAvailable else { return }
        
        await set(isLoading: true)
        
         /*
         User Story 3.
         As a user of the App, I want to get feedback when loading of the transactions is ongoing or an Error occurs. (Just delay the mocked server response for 1-2 seconds and randomly fail it)
        */
        /*
         if Bool.random() {
            await set(isLoading: false)
            await set(bannerData: BannerViewModifier.BannerData(title: "Error", details: "Some network error", type: .error))
            return
        }
        */
        
        guard let url = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") else {
            await set(bannerData: BannerViewModifier.BannerData(title: "Error", details: "Failed to load JSON data", type: .error))
            return
        }
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate a 1 second
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode(TransactionList.self, from: data)
            let transactions = decodedData.items
                .sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate })
            self.transactions = transactions
            let categories = Array(Set(transactions.map(\.category))).sorted()
            await set(categoryFilterPickerOptions: [(-1, "All")] + categories.map { (id: $0, title: "Category \($0)") })
        } catch {
            print(error)
            await set(bannerData: BannerViewModifier.BannerData(title: "Error", details: error.localizedDescription, type: .error))
        }

        await set(isLoading: false)
    }
    
    // MARK: - Init
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            Task { [weak self] in
                let isNetworkAvailable = path.status == .satisfied
                self?.isNetworkAvailable = isNetworkAvailable
                if !isNetworkAvailable {
                    await self?.set(bannerData: BannerViewModifier.BannerData(title: "Error", details: "Network is not available", type: .error))
                } else {
                    await self?.set(bannerData: nil)
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    // MARK: - Private
    
    private var isNetworkAvailable = true
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var transactions = [TransactionItem]()
    
    @MainActor
    private func set(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    @MainActor
    private func set(bannerData: BannerViewModifier.BannerData?) {
        self.bannerData = bannerData
    }
    
    @MainActor
    private func set(categoryFilterPickerOptions: [(id: Int, title: String)]) {
        self.categoryFilterPickerOptions = categoryFilterPickerOptions
    }
}
