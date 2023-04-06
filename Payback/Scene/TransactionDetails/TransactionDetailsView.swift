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
            .background(Color.brandBackground.edgesIgnoringSafeArea(.horizontal))
            .navigationTitle("Transaction Detail")
    }
}

struct Previews_TransactionDetailsView_Previews: PreviewProvider {
    
    static var transaction: Transaction {
        let json = """
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
            }
        """
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try! decoder.decode(Transaction.self, from: jsonData)
    }
    
    static var previews: some View {
        TransactionDetailsView(transaction: transaction)
    }
}
