//
//  TransactionListView.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI
import PaybackCommon

public struct TransactionListView<VM: TransactionListViewModel>: View {
    
    @StateObject var viewModel: VM
    @State private var dataLoaded = false
    
    public init(viewModel: VM) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
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
                        TransactionListItemView(
                            transaction: transaction,
                            detailsProvider: viewModel.detailsProvider
                        )
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
    static let viewModel = Transaction.ViewModel(
        transactionService: TransactionServiceMock(),
        translationService: TranslationServiceMock(),
        reachabilityService: ReachabilityServiceMock()) { transaction in Text("Details") }
    static var previews: some View {
        TransactionListView(viewModel: viewModel)
    }
}
