//
//  TransactionService+Mock.swift
//  Payback
//
//  Created by Pronin Oleksandr on 08.04.23.
//

import Foundation
import Combine

extension Transaction {
    enum Errors: LocalizedError, Equatable {
        case invalidJSON
    }
}

extension Transaction.Errors {
    public var errorDescription: String? {
        switch self {
        case .invalidJSON: return "Failed to load JSON data"
        }
    }
}

struct TransactionServiceMock: TransactionService {
    var transactions: AnyPublisher<TransactionList, Error> {
        guard let url = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") else {
            return Fail(error: Transaction.Errors.invalidJSON).eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TransactionList.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
