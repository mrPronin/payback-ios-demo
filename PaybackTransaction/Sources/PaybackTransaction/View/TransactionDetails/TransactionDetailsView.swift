//
//  TransactionDetailsView.swift
//  Payback
//
//  Created by Pronin Oleksandr on 03.04.23.
//

import SwiftUI
import PaybackCommon

public struct TransactionDetailsView: View {
    let transaction: TransactionItem
    
    public init(transaction: TransactionItem) {
        self.transaction = transaction
    }
    
    public var body: some View {
        VStack {
            HStack {
                Text("Partner display name:")
                    .font(.headline)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Text(transaction.partnerDisplayName)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
            }
            .padding(.vertical)
            .background(.white)
            .cornerRadius(8)
            
            VStack {
                HStack {
                    Text("Description:")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                    Text(transaction.transactionDetail.description ?? "No description provided")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                HStack {
                    Text("Booking date:")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                    Text(transaction.transactionDetail.bookingDate, style: .date)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical)
            .background(.white)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
        .background(Color.brandBackground.edgesIgnoringSafeArea(.horizontal))
        .navigationTitle("Transaction Detail")
    }
}

struct Previews_TransactionDetailsView_Previews: PreviewProvider {
    
    static var transaction: TransactionItem {
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
        return try! decoder.decode(TransactionItem.self, from: jsonData)
    }
    
    static var previews: some View {
        TransactionDetailsView(transaction: transaction)
    }
}
