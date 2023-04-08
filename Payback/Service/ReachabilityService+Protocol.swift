//
//  Reachability+Service.swift
//  Payback
//
//  Created by Pronin Oleksandr on 08.04.23.
//

import Combine
import Network

public protocol ReachabilityService {
    var publisher: AnyPublisher<NWPath, Never> { get }
}
