//
//  EndpointTest.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation
@testable import PaybackCommon
import XCTest

class EndpointTest: XCTestCase {
    typealias StubbedEndpoint = Endpoint<EndpointKinds.Stub, String, String>
    let host = URLHost(rawValue: "test")
    
    func testBasicRequestGeneration() throws {
        let endpoint = StubbedEndpoint(path: "path")
        let request = endpoint.makeRequest(with: (), host: host)
        
        try XCTAssertEqual(request?.url, host.expectedURL(withPath: "path"))
    }

}
