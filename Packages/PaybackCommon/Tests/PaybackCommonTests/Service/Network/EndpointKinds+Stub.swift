//
//  EndpointKinds+Stub.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import XCTest
@testable import PaybackCommon

extension EndpointKinds {
    enum Stub: EndpointKind {
        static func prepare(_ request: inout URLRequest, with data: Void) {
            // No-op
        }
    }
}
