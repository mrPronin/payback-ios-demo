//
//  URLHost.swift
//  Payback
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation

struct URLHost: RawRepresentable {
    var rawValue: String
}

extension URLHost {
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
