//
//  TransactionListView.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI
import Combine
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
                Picker(viewModel.translationService.localizedString(with: "transaction_list_category"), selection: $viewModel.selectedCategoryFilter) {
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
                            Text(viewModel.translationService.localizedString(with: "transaction_list_total"))
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
            .navigationTitle(viewModel.translationService.localizedString(with: "transaction_list_title"))
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
    struct TransactionServiceMock: TransactionService {
        var transactions: AnyPublisher<TransactionList, Error> {
            let json = """
            {
                "items": [
                    {
                      "partnerDisplayName": "REWE Group",
                      "alias": {
                        "reference": "795357452000810"
                      },
                      "category": 1,
                      "transactionDetail": {
                        "description": "Punkte sammeln",
                        "bookingDate": "2022-07-24T10:59:05+0200",
                        "value": {
                          "amount": 124,
                          "currency": "PBP"
                        }
                      }
                    },
                    {
                      "partnerDisplayName": "dm-dogerie markt",
                      "alias": {
                        "reference": "098193809705561"
                      },
                      "category": 1,
                      "transactionDetail": {
                        "description": "Punkte sammeln",
                        "bookingDate": "2022-06-23T10:59:05+0200",
                        "value": {
                          "amount": 1240,
                          "currency": "PBP"
                        }
                      }
                    },
                    {
                      "partnerDisplayName": "OTTO Group",
                      "alias": {
                        "reference": "094844835601044"
                      },
                      "category": 2,
                      "transactionDetail": {
                        "bookingDate": "2022-07-22T10:59:05+0200",
                        "value": {
                          "amount": 53,
                          "currency": "PBP"
                        }
                      }
                    }
                ]
            }
            """
            let jsonData = json.data(using: .utf8)!
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodecData = try! decoder.decode(TransactionList.self, from: jsonData)
            return Just(decodecData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    static let viewModel = Transaction.ViewModel(
        transactionService: TransactionServiceMock(),
        translationService: Translation.ServiceMock(),
        reachabilityService: Reachability.ServiceMock()) { transaction in Text("Details") }
    static var previews: some View {
        TransactionListView(viewModel: viewModel)
    }
}
