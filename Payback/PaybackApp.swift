//
//  PaybackApp.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI
import PaybackTransaction
import Tabbar

@main
struct PaybackApp: App {
    
    private static func goToDetails(transaction: TransactionItem) -> TransactionDetailsView {
        TransactionDetailsView(transaction: transaction, translationService: translation)
    }
    
    // We could reuse this services in other features later as well
    private static let reachability = Reachability.Service()
    private static let translation = Translation.Service()
    
    let transactionViewModel = Transaction.ViewModel(
        transactionService: Transaction.ServiceMock(),
        translationService: translation,
        reachabilityService: reachability,
        detailsProvider: goToDetails
    )

    var body: some Scene {
        WindowGroup {
            if FeatureFlags.tabbarEnabled {
                Tabbar(tabProviders: tabProviders)
            } else {
                TransactionListView(viewModel: transactionViewModel)
            }
        }
    }
    
    var tabProviders: [TabViewProvider] {
        var tabProviders = [TabViewProvider]()
        
        if FeatureFlags.transactionEnabled {
            tabProviders.append(transactionTabProvider)
        }
        
        if FeatureFlags.feedEnabled {
            tabProviders.append(feedTabProvider)
        }
        
        if FeatureFlags.onlineShoppingEnabled {
            tabProviders.append(onlineShoppingTabProvider)
        }
        
        if FeatureFlags.settingsEnabled {
            tabProviders.append(settingsTabProvider)
        }

        return tabProviders
    }
    
    var transactionTabProvider: TabViewProvider {
        return .init(
            systemImageName: "repeat.1.circle",
            tabName: PaybackApp.translation.localizedString(with: "transaction_list_tab_name")) {
                return TransactionListView(viewModel: transactionViewModel).erased
            }
    }
    
    var feedTabProvider: TabViewProvider {
        return .init(
            systemImageName: "server.rack",
            tabName: PaybackApp.translation.localizedString(with: "feed_tab_name")) {
                return FeedView().erased
            }
    }
    
    var onlineShoppingTabProvider: TabViewProvider {
        return .init(
            systemImageName: "cart.circle.fill",
            tabName: PaybackApp.translation.localizedString(with: "online_shopping_tab_name")) {
                return OnlineShoppingView().erased
            }
    }
    
    var settingsTabProvider: TabViewProvider {
        return .init(
            systemImageName: "gear.circle",
            tabName: PaybackApp.translation.localizedString(with: "settings_tab_name")) {
                return SettingsView().erased
            }
    }
}

extension View {
    var erased: AnyView {
        return AnyView(self)
    }
}
