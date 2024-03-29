//
//  URLHost.swift
//  Payback
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation

public struct URLHost: RawRepresentable {
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    public var rawValue: String
}

public extension URLHost {
    static var test: Self {
        URLHost(rawValue: Constants.baseURLTest)
    }

    static var prod: Self {
        URLHost(rawValue: Constants.baseURL)
    }

    static var `default`: Self {
        #if DEBUG
        return test
        #else
        return prod
        #endif
    }
}
