//
//  TransactionService+Mock.swift
//  Payback
//
//  Created by Pronin Oleksandr on 08.04.23.
//

import Foundation
import Combine

public extension Transaction {
    struct ServiceMock: TransactionService {
        public init() {}
        public var transactions: AnyPublisher<TransactionList, Error> {
            
            /*
             User Story 3.
             As a user of the App, I want to get feedback when loading of the transactions is ongoing or an Error occurs. (Just delay the mocked server response for 1-2 seconds and randomly fail it)
             */
            /*
             if Bool.random() {
                 return Fail(error: Network.Errors.unknownError(404))
                     .delay(for: 1, scheduler: RunLoop.main)
                     .eraseToAnyPublisher()
             }
             */

            guard let url = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") else {
                return Fail(error: Transaction.Errors.invalidJSON).eraseToAnyPublisher()
            }
            guard let jsonData = try? Data(contentsOf: url) else {
                return Fail(error: Transaction.Errors.invalidJSON).eraseToAnyPublisher()
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let decodedData = try? decoder.decode(TransactionList.self, from: jsonData) else {
                return Fail(error: Transaction.Errors.invalidJSON).eraseToAnyPublisher()
            }
            
            return Just(decodedData)
                .delay(for: 1, scheduler: RunLoop.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
