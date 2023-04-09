//
//  EndpointKind.swift
//  Payback
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation

protocol EndpointKind {
    associatedtype RequestData
    static func prepare(_ request: inout URLRequest, with data: RequestData)
}

enum EndpointKinds {
    enum Public: EndpointKind {
        static func prepare(_ request: inout URLRequest, with _: Void) {
            // Here we can do things like assign a custom cache
            // policy for loading our publicly available data.
        }
    }
    
    enum Private: EndpointKind {
        static func prepare(_ request: inout URLRequest, with token: AccessToken) {
            // Here we can attach authentication data
            request.addValue("Bearer \(token.rawValue)", forHTTPHeaderField: "Authorization")
        }
    }
}
