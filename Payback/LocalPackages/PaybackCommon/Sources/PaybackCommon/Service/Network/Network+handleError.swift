//
//  Network+handleError.swift
//  Payback
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation

public extension Network {
    static func handleError(_ error: Error) -> Network.Errors {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as Network.Errors:
            return error
        default:
            return .other(description: error.localizedDescription)
        }
    }
}
