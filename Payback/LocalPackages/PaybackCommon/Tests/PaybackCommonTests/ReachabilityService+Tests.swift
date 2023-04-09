//
//  ReachabilityService+Tests.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import XCTest
@testable import PaybackCommon
import Combine

final class ReachabilityServiceTests: XCTestCase {
    var sut: Reachability.Service!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = Reachability.Service()
        subscriptions = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        subscriptions = nil
    }
    
    func testReachabilityPublisherValue() {
        let expectation = expectation(description: "Value")
        var isExpectationFulfilled = false
        
        sut.publisher
            .sink { _ in
                //
            } receiveValue: { path in
                if isExpectationFulfilled {
                    XCTFail("Expectation fulfilled more than once")
                }
                else {
                    isExpectationFulfilled = true
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 10)
    }
    
    func testReachabilityPublisherCompletion() {
        let expectation = expectation(description: "Completion")
        
        sut.publisher
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { _ in
                //
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 10)
    }
}
