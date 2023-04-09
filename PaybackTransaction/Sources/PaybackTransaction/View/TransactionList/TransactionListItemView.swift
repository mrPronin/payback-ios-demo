//
//  TransactionListItemView.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI
import PaybackCommon

public struct TransactionListItemView<DetailsView: View>: View {
    
    let transaction: TransactionItem
    let detailsProvider: TransactionDetailsProvider<DetailsView>
    
    init(transaction: TransactionItem, detailsProvider: @escaping TransactionDetailsProvider<DetailsView>) {
        self.transaction = transaction
        self.detailsProvider = detailsProvider
    }
    
    public var body: some View {
        NavigationLink(destination: detailsProvider(transaction)) {
            VStack(alignment: .leading) {
                Text(transaction.partnerDisplayName)
                    .font(.headline)
                Text(transaction.transactionDetail.description ?? "description_not_provided".localized)
                    .font(.subheadline)
                HStack {
                    Text(transaction.transactionDetail.bookingDate, style: .date)
                    Spacer()
                    Text(transaction.transactionDetail.value.amount, format: .currency(code: transaction.transactionDetail.value.currency))
                }
            }
        }
    }
}
