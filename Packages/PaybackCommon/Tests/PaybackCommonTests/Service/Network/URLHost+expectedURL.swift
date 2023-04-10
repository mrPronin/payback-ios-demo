//
//  URLHost+expectedURL.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation
@testable import PaybackCommon
import XCTest

public extension URLHost {
    func expectedURL(withPath path: String) throws -> URL {
        let url = URL(string: "https://" + rawValue + "/" + path)
        return try XCTUnwrap(url)
    }
}

