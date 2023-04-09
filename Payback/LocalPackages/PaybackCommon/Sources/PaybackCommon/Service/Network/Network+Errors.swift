//
//  Network+Errors.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation

public extension Network {
    enum Errors: Error, Equatable {
        case invalidURL
        case badRequest
        case unauthorized
        case forbidden
        case notFound
        case error4xx(_ code: Int)
        case serverError
        case error5xx(_ code: Int)
        case decodingError
        case urlSessionFailed(_ error: URLError)
        case unknownError(_ code: Int)
        case other(description: String)
    }
    static func error(from statusCode: Int) -> Errors {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError(statusCode)
        }
    }
}

// MARK: - LocalizedError
extension Network.Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL: return NSLocalizedString("network_error_invalid_url", bundle: .module, comment: "")
        case .badRequest: return NSLocalizedString("network_error_bad_request", bundle: .module, comment: "")
        case .unauthorized: return NSLocalizedString("network_error_unauthorized", bundle: .module, comment: "")
        case .forbidden: return NSLocalizedString("network_error_forbidden", bundle: .module, comment: "")
        case .notFound: return NSLocalizedString("network_error_link_not_found", bundle: .module, comment: "")
        case .error4xx(let code): return String.localizedStringWithFormat(NSLocalizedString("network_error_with_code", bundle: .module, comment: ""), "\(code)")
        case .serverError: return NSLocalizedString("network_error_server_exception", bundle: .module, comment: "")
        case .error5xx(let code): return String.localizedStringWithFormat(NSLocalizedString("network_error_with_code", bundle: .module, comment: ""), "\(code)")
        case .decodingError: return NSLocalizedString("network_error_decoding_failed", bundle: .module, comment: "")
        case .urlSessionFailed(let error): return String.localizedStringWithFormat(NSLocalizedString("network_error_url_session_failed_with_error", bundle: .module, comment: ""), "\(error.localizedDescription)")
        case .unknownError: return NSLocalizedString("network_error_unknown", bundle: .module, comment: "")
        case .other(description: let description):
            return String.localizedStringWithFormat(NSLocalizedString("network_error_url_session_failed_with_error", bundle: .module, comment: ""), "\(description)")
        }
    }
}
