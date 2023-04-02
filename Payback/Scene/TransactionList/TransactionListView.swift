//
//  TransactionListView.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI

struct TransactionListView: View {
    
    @StateObject var viewModel = TransactionListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.transactions) { transaction in
                        TransactionListItemView(transaction: transaction)
                    }
                }
            }
            .banner(data: $viewModel.bannerData)
            .navigationTitle("Transactions")
            .onAppear {
                viewModel.fetchTransactions()
            }
        }
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}
