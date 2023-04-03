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
                    Picker("Category", selection: $viewModel.selectedCategoryFilter) {
                        ForEach(viewModel.categoryFilterPickerOptions, id: \.id) { option in
                            Text(option.title)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    List(viewModel.filteredTransactions) { transaction in
                        TransactionListItemView(transaction: transaction)
                    }
                    .padding(.vertical)
                    .padding(.top, 0)
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
