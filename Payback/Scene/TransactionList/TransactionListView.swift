//
//  TransactionListView.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI

struct TransactionListView: View {
    
    @StateObject var viewModel = TransactionListViewModel()
    @State private var dataLoaded = false
    
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
                    .padding(.top, 0)
                    .background(Color.brandBackground)
                    .scrollContentBackground(.hidden)
                    
                    HStack {
                        Spacer()
                        Text("Total: \(String(format: "%.02f", viewModel.filteredTransactionsTotal))")
                            .padding(.top)
                            .padding(.bottom)
                            .padding(.trailing)
                            .fontWeight(.semibold)
                    }
                }
            }
            .banner(data: $viewModel.bannerData)
            .navigationTitle("Transactions")
            .onAppear {
                if !dataLoaded {
                    viewModel.fetchTransactions()
                    dataLoaded = true
                }
            }
        }
    }
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}
