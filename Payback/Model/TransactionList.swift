//
//  TransactionList.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import Foundation

public struct TransactionList: Decodable {
    let items: [TransactionItem]
}
