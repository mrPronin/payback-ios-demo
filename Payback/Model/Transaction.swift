//
//  Transaction.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import Foundation

struct Transaction: Decodable, Identifiable {
    var id = UUID()
    let partnerDisplayName: String
    let alias: Alias
    let category: Int
    let transactionDetail: TransactionDetail
    
    struct Alias: Decodable {
        let reference: String
    }
    
    struct TransactionDetail: Decodable {
        let description: String?
        let bookingDate: Date
        let value: Value
        
        struct Value: Decodable {
            let amount: Double
            let currency: String
        }
    }
}
