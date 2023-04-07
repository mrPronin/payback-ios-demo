//
//  TransactionListView.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI
import PaybackCommon

struct TransactionListView: View {
    
    @StateObject var viewModel = TransactionListViewModel()
    @State private var dataLoaded = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Category", selection: $viewModel.selectedCategoryFilter) {
                    ForEach(viewModel.categoryFilterPickerOptions, id: \.id) { option in
                        Text(option.title)
                    }
                }
                .pickerStyle(.navigationLink)
                .padding(.horizontal)
                .padding(.top, 8)
                
                ZStack {
                    List(viewModel.filteredTransactions) { transaction in
                        TransactionListItemView(transaction: transaction)
                    }
                    .padding(.top, 0)
                    .background(Color.brandBackground)
                    .scrollContentBackground(.hidden)
                    .refreshable {
                        await viewModel.fetchTransactions()
                        dataLoaded = true
                    }
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
                
                if viewModel.filteredTransactionsTotal > 0 {
                    HStack {
                        Spacer()
                        HStack {
                            Text("Total:")
                                .fontWeight(.semibold)
                            Text(viewModel.filteredTransactionsTotal, format: .currency(code: viewModel.transactionsCurrency))
                        }
                        .padding(.top)
                        .padding(.bottom)
                        .padding(.trailing)
                    }
                }
            }
            .banner(data: $viewModel.bannerData)
            .navigationTitle("Transactions")
            .task {
                if !dataLoaded {
                    await viewModel.fetchTransactions()
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
