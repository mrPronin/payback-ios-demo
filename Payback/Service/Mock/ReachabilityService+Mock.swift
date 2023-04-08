//
//  ReachabilityService+Mock.swift
//  Payback
//
//  Created by Pronin Oleksandr on 08.04.23.
//

import Combine
import Network

struct ReachabilityServiceMock: ReachabilityService {
    var publisher: AnyPublisher<NWPath.Status, Never> {
        return Just(.satisfied).eraseToAnyPublisher()
    }
}
