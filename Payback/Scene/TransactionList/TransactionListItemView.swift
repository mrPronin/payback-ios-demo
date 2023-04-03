//
//  TransactionListItemView.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI

struct TransactionListItemView: View {
    
    let transaction: Transaction
    
    var body: some View {
        NavigationLink(destination: TransactionDetailsView(transaction: transaction)) {
            VStack(alignment: .leading) {
                Text(transaction.partnerDisplayName)
                    .font(.headline)
                Text(transaction.transactionDetail.description ?? "Description not provided")
                    .font(.subheadline)
                HStack {
                    Text(transaction.transactionDetail.bookingDate, style: .date)
                    Spacer()
                    Text("\(String(format: "%.02f", transaction.transactionDetail.value.amount)) \(transaction.transactionDetail.value.currency)")
                }
            }
        }
    }
}
