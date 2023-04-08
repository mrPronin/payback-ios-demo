//
//  PaybackApp.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI

@main
struct PaybackApp: App {
    let viewModel = Transaction.ViewModel(
        transactionService: TransactionServiceMock(),
        translationService: TranslationServiceMock(),
        reachabilityService: ReachabilityServiceMock()
    )

    var body: some Scene {
        WindowGroup {
            TransactionListView(viewModel: viewModel)
        }
    }
}
