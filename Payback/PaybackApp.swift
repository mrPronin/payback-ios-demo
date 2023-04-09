//
//  PaybackApp.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI
import PaybackTransaction

@main
struct PaybackApp: App {
    
    private static func goToDetails(transaction: TransactionItem) -> TransactionDetailsView { TransactionDetailsView(transaction: transaction) }
    
    let viewModel = PaybackCommon.Transaction.ViewModel(
        transactionService: TransactionServiceMock(),
        translationService: TranslationServiceMock(),
        reachabilityService: ReachabilityServiceMock(),
        detailsProvider: goToDetails
    )

    var body: some Scene {
        WindowGroup {
            TransactionListView(viewModel: viewModel)
        }
    }
}
