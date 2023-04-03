//
//  TransactionDetailsView.swift
//  Payback
//
//  Created by Pronin Oleksandr on 03.04.23.
//

import SwiftUI

struct TransactionDetailsView: View {
    let transaction: Transaction
    
    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Partner display name:")
                        .font(.headline)
                    Spacer()
                    Text(transaction.partnerDisplayName)
                }
                
                HStack {
                    Text("Description:")
                        .font(.headline)
                    Spacer()
                    Text(transaction.transactionDetail.description ?? "No description provided")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Transaction Detail")    }
}
