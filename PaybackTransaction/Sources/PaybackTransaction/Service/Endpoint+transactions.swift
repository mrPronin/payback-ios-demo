//
//  File.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation
import PaybackCommon

extension Endpoint where Kind == EndpointKinds.Public, Response == TransactionList, Payload == String {
    static var transactions: Self {
        Endpoint(path: "transactions")
    }
}
