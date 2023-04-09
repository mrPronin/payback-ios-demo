//
//  TransactionService.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation
import Combine

public extension Transaction {
    struct Service: TransactionService {
        public init() {}
        public var transactions: AnyPublisher<TransactionList, Error> {
            return URLSession.shared.publisher(for: .transactions)
                .eraseToAnyPublisher()
        }
    }
}
