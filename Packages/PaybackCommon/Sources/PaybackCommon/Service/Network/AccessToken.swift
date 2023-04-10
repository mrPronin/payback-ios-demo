//
//  AccessToken.swift
//  Payback
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation

public struct AccessToken: RawRepresentable {
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    public var rawValue: String
}
