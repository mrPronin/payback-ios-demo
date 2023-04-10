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
    
    public init(transaction: TransactionItem, translationService: TranslationService) {
        self.transaction = transaction
        self.translationService = translationService
    }
    
    public var body: some View {
        VStack {
            HStack {
                Text(translationService.localizedString(with: "transaction_details_partner_name"))
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
                    Text(translationService.localizedString(with: "transaction_details_description"))
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                    Text(transaction.transactionDetail.description ?? "".localized)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                HStack {
                    Text(translationService.localizedString(with: "transaction_details_booking_date"))
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
        .navigationTitle(translationService.localizedString(with: "transaction_details_title"))
    }
    
    // MARK: - Private
    private let translationService: TranslationService
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
        TransactionDetailsView(
            transaction: transaction,
            translationService: Translation.Service()
        )
    }
}
