//
//  TransactionService+Mock.swift
//  Payback
//
//  Created by Pronin Oleksandr on 08.04.23.
//

import Foundation
import Combine

public extension Transaction {
    class ServiceMock: TransactionService {
        // MARK: - Public
        public var transactionList: TransactionList?
        public var error: Error?
        public init() {
            transactionList = seedTransactionList()
        }
        private func seedTransactionList() -> TransactionList? {
            guard let url = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") else {
                return nil
            }
            guard let jsonData = try? Data(contentsOf: url) else {
                return nil
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            guard let decodedData = try? decoder.decode(TransactionList.self, from: jsonData) else {
                return nil
            }
            return decodedData
        }
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
            if let error = error {
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            guard let transactionList = transactionList else {
                return Fail(error: Transaction.Errors.invalidJSON).eraseToAnyPublisher()
            }
            
            return Just(transactionList)
                .delay(for: 1, scheduler: RunLoop.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
