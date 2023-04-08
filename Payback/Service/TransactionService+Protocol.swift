//
//  TransactionService+Protocol.swift
//  Payback
//
//  Created by Pronin Oleksandr on 08.04.23.
//

import Combine

public protocol TransactionService {
    var transactions: AnyPublisher<TransactionList, Error> { get }
}
