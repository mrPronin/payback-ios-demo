//
//  File.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation

public extension Transaction {
    enum Errors: LocalizedError, Equatable {
        case invalidJSON
        case someNetworkError
    }
}

public extension Transaction.Errors {
    var errorDescription: String? {
        switch self {
        case .invalidJSON: return "Failed to load JSON data"
        case .someNetworkError: return "Some network error"
        }
    }
}
