//
//  TransactionItem.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import Foundation

public struct TransactionItem: Decodable, Identifiable {
    public let id: UUID
    let partnerDisplayName: String
    let alias: Alias
    let category: Int
    let transactionDetail: TransactionDetail
    
    private enum CodingKeys: String, CodingKey {
        case id
        case partnerDisplayName
        case alias
        case category
        case transactionDetail
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        partnerDisplayName = try container.decode(String.self, forKey: .partnerDisplayName)
        alias = try container.decode(Alias.self, forKey: .alias)
        category = try container.decode(Int.self, forKey: .category)
        transactionDetail = try container.decode(TransactionDetail.self, forKey: .transactionDetail)
    }

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
