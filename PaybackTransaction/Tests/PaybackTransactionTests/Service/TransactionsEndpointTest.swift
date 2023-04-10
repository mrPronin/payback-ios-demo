//
//  TransactionsEndpointTest.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import XCTest
@testable import PaybackTransaction

class TransactionsEndpointTest: XCTestCase {
    let host = URLHost(rawValue: "test")
    
    func testTransactionsEndpoint() throws {
        let endpoint = Endpoint.transactions
        let request = endpoint.makeRequest(with: (), host: host)
        try XCTAssertEqual(request?.url, host.expectedURL(withPath: "transactions"))
        XCTAssertEqual(request?.httpMethod, Network.HTTPMethod.get.rawValue)
        XCTAssertEqual(request?.allHTTPHeaderFields, [
            "Content-Type": "application/json"
        ])
    }
}
