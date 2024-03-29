//
//  Transaction+ViewModel.swift
//  Payback
//
//  Created by Pronin Oleksandr on 08.04.23.
//

import Foundation
import Combine
import SwiftUI

public typealias TransactionDetailsProvider<Details: View> = (TransactionItem) -> Details

public protocol TransactionViewModel: ObservableObject {
    associatedtype DetailsView: View
    var isLoading: Bool { get }
    var bannerData: BannerViewModifier.BannerData? { get set }
    var categoryFilterPickerOptions: [(id: Int, title: String)] { get }
    var selectedCategoryFilter: Int { get set }
    var filteredTransactions: [TransactionItem] { get }
    var filteredTransactionsTotal: Double { get }
    var transactionsCurrency: String { get }
    func fetchTransactions() async
    var detailsProvider: TransactionDetailsProvider<DetailsView> { get }
    var translationService: TranslationService { get }
}

public extension Transaction {
    class ViewModel<DetailsView: View>: TransactionViewModel {
        
        // MARK: - Public
        public let translationService: TranslationService
        @Published private(set) public var isLoading = false
        @Published public var bannerData: BannerViewModifier.BannerData? = nil
        @Published private(set) public var categoryFilterPickerOptions: [(id: Int, title: String)] = []
        @Published public var selectedCategoryFilter: Int = -1 {
            didSet {
                objectWillChange.send()
            }
        }
        
        public var filteredTransactions: [TransactionItem] {
            guard selectedCategoryFilter != -1 else {
                return transactions
            }
            return transactions.filter { $0.category == selectedCategoryFilter }
        }
        
        public var filteredTransactionsTotal: Double {
            return filteredTransactions.reduce(0.0) { $0 + $1.transactionDetail.value.amount }
        }

        public var transactionsCurrency: String {
            guard let currency = Array(Set(filteredTransactions.map(\.transactionDetail.value.currency))).first else {
                return ""
            }
            return currency
        }
        
        public func fetchTransactions() async {
            guard isNetworkAvailable else { return }
            await set(isLoading: true)
            
            do {
                let transactions: [TransactionItem] = try await withCheckedThrowingContinuation { continuation in
                    transactionService.transactions
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished: break
                            case .failure(let error):
                                continuation.resume(throwing: error)
                                break
                            }
                        }, receiveValue: { transactionList in
                            continuation.resume(
                                returning: transactionList.items
                                    .sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate })
                            )
                        })
                        .store(in: &cancellables)
                }
                self.transactions = transactions
                let categories = Array(Set(transactions.map(\.category))).sorted()
                await set(categoryFilterPickerOptions: [(-1, translationService.localizedString(with: "transaction_list_all_categories"))] + categories.map { (id: $0, title: "\(translationService.localizedString(with: "transaction_list_category")) \($0)") })
            } catch {
                await set(bannerData: BannerViewModifier.BannerData(title: translationService.localizedString(with: "error"), details: error.localizedDescription, type: .error))
            }
            await set(isLoading: false)
        }
        
        public let detailsProvider: TransactionDetailsProvider<DetailsView>
        
        // MARK: - Init
        
        public init(
            transactionService: TransactionService,
            translationService: TranslationService,
            reachabilityService: ReachabilityService,
            detailsProvider: @escaping TransactionDetailsProvider<DetailsView>
        ) {
            self.transactionService = transactionService
            self.translationService = translationService
            self.reachabilityService = reachabilityService
            self.detailsProvider = detailsProvider
            
            self.reachabilityService.publisher
                .sink { status in
                    Task { [weak self] in
                        self?.isNetworkAvailable = status == .satisfied
                        guard status == .satisfied else {
                            await self?.set(bannerData: BannerViewModifier.BannerData(title: translationService.localizedString(with: "error"), details: translationService.localizedString(with: "error_notwork_is_not_available"), type: .error))
                            return
                        }
                        await self?.set(bannerData: nil)
                    }
                }
                .store(in: &cancellables)
                
        }

        // MARK: - Private
        private var isNetworkAvailable = true
        private var transactions = [TransactionItem]()
        private let transactionService: TransactionService
        private let reachabilityService: ReachabilityService
        private var cancellables: Set<AnyCancellable> = []
        
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
}
