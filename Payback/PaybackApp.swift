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
    
    private static func goToDetails(transaction: TransactionItem) -> TransactionDetailsView {
        TransactionDetailsView(transaction: transaction, translationService: translation)
    }
    
    // We could reuse this service in other features later as well
    private static let reachability = Reachability.Service()
    private static let translation = Translation.Service()
    
    let viewModel = Transaction.ViewModel(
        transactionService: Transaction.ServiceMock(),
        translationService: translation,
        reachabilityService: reachability,
        detailsProvider: goToDetails
    )

    var body: some Scene {
        WindowGroup {
            TransactionListView(viewModel: viewModel)
        }
    }
}
