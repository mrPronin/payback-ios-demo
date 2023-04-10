//
//  TransactionViewModelTests.swift
//  
//
//  Created by Pronin Oleksandr on 10.04.23.
//

import XCTest
@testable import PaybackTransaction
import Combine
import SwiftUI

class TransactionViewModelTests: XCTestCase {
    var sut: PaybackTransaction.Transaction.ViewModel<AnyView>!
    
    var transactionService: PaybackTransaction.Transaction.ServiceMock!
    var translationService: Translation.ServiceMock!
    var reachabilityService: Reachability.ServiceMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        transactionService = PaybackTransaction.Transaction.ServiceMock()
        translationService = Translation.ServiceMock()
        reachabilityService = Reachability.ServiceMock()
        sut = PaybackTransaction.Transaction.ViewModel(
            transactionService: transactionService,
            translationService: translationService,
            reachabilityService: reachabilityService,
            detailsProvider: { _ in AnyView(EmptyView()) }
        )
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        reachabilityService = nil
        translationService = nil
        transactionService = nil
        cancellables = nil
    }
    
    func testFetchTransactionsSuccess() async {
        // given
        transactionService.transactionList = transactionList
        let expectedTotal = transactionList.items.reduce(0.0) { $0 + $1.transactionDetail.value.amount }
        let expectedCurrency = Array(Set(transactionList.items.map(\.transactionDetail.value.currency))).first
        let expectedCategoryCount = Array(Set(transactionList.items.map(\.category))).count + 1
        
        // when
        await sut.fetchTransactions()
        
        // then
        XCTAssertEqual(sut.filteredTransactions.count, transactionService.transactionList?.items.count)
        XCTAssertEqual(sut.filteredTransactionsTotal, expectedTotal)
        XCTAssertEqual(sut.transactionsCurrency, expectedCurrency)
        XCTAssertEqual(sut.categoryFilterPickerOptions.count, expectedCategoryCount)
        XCTAssertEqual(sut.categoryFilterPickerOptions.first?.id, -1)
    }
    
    func testFetchTransactionsError() async {
        // given
        transactionService.error = Transaction.Errors.invalidJSON
        
        // when
        await sut.fetchTransactions()
        
        // then
        XCTAssertNotNil(sut.bannerData)
        XCTAssertEqual(sut.bannerData?.type, .error)
    }
    
    func testIsLoadingInitiallyFalse() {
        XCTAssertFalse(sut.isLoading)
    }
    
    func testBannerDataInitiallyNil() {
        XCTAssertNil(sut.bannerData)
    }
    
    func testCategoryFilterPickerOptionsInitiallyEmpty() {
        XCTAssertTrue(sut.categoryFilterPickerOptions.isEmpty)
    }
    
    func testSelectedCategoryFilterInitiallyNegativeOne() {
        XCTAssertEqual(sut.selectedCategoryFilter, -1)
    }
    
    func testFilteredTransactionsInitiallyEmpty() {
        XCTAssertTrue(sut.filteredTransactions.isEmpty)
    }
    
    func testFilteredTransactionsTotalInitiallyZero() {
        XCTAssertEqual(sut.filteredTransactionsTotal, 0.0)
    }
    
    func testTransactionsCurrencyInitiallyEmpty() {
        XCTAssertEqual(sut.transactionsCurrency, "")
    }
    
    private var transactionList: TransactionList {
        let json = """
        {
            "items": [
                {
                  "partnerDisplayName": "REWE Group",
                  "alias": {
                    "reference": "795357452000810"
                  },
                  "category": 1,
                  "transactionDetail": {
                    "description": "Punkte sammeln",
                    "bookingDate": "2022-07-24T10:59:05+0200",
                    "value": {
                      "amount": 124,
                      "currency": "PBP"
                    }
                  }
                },
                {
                  "partnerDisplayName": "dm-dogerie markt",
                  "alias": {
                    "reference": "098193809705561"
                  },
                  "category": 1,
                  "transactionDetail": {
                    "description": "Punkte sammeln",
                    "bookingDate": "2022-06-23T10:59:05+0200",
                    "value": {
                      "amount": 1240,
                      "currency": "PBP"
                    }
                  }
                },
                {
                  "partnerDisplayName": "OTTO Group",
                  "alias": {
                    "reference": "094844835601044"
                  },
                  "category": 2,
                  "transactionDetail": {
                    "bookingDate": "2022-07-22T10:59:05+0200",
                    "value": {
                      "amount": 53,
                      "currency": "PBP"
                    }
                  }
                }
            ]
        }
        """
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try! decoder.decode(TransactionList.self, from: jsonData)
    }
}
