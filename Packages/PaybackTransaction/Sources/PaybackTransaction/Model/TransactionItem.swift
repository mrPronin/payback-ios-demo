//
//  TransactionItem.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import Foundation

public struct TransactionItem: Codable, Identifiable, Equatable {
    public let id: UUID
    public let partnerDisplayName: String
    public let alias: Alias
    public let category: Int
    public let transactionDetail: TransactionDetail
    
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

    public struct Alias: Codable {
        public let reference: String
    }

    public struct TransactionDetail: Codable {
        public let description: String?
        public let bookingDate: Date
        public let value: Value

        public struct Value: Codable {
            public let amount: Double
            public let currency: String
        }
    }
    
    public static func == (lhs: TransactionItem, rhs: TransactionItem) -> Bool {
        return lhs.id == rhs.id
    }
}
