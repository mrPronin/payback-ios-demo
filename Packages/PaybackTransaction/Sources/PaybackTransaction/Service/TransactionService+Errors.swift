//
//  TransactionService+Errors.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation

public extension Transaction {
    enum Errors: LocalizedError, Equatable {
        case invalidJSON
    }
}

public extension Transaction.Errors {
    var errorDescription: String? {
        switch self {
        case .invalidJSON: return "transaction_error_failed_to_load_json".localized
        }
    }
}
