//
//  Transaction.swift
//  Payback
//
//  Created by Pronin Oleksandr on 07.04.23.
//

import SwiftUI
import Combine
import PaybackCommon

// define namespace
public enum Transaction {}

public typealias TransactionDetailsProvider<Details: View> = (TransactionItem) -> Details

public protocol TransactionListViewModel: ObservableObject {
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
}
