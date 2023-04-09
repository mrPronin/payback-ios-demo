//
//  Network+httpMethod.swift
//  Payback
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation
import PaybackCommon

extension Network {
    enum HTTPMethod: String {
        case get     = "GET"
        case post    = "POST"
        case put     = "PUT"
        case delete  = "DELETE"
    }
}

