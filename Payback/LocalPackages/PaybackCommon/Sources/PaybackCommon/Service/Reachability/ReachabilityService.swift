//
//  ReachabilityService.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Combine
import Network

public extension Reachability {
    final class Service: ReachabilityService {
        // MARK: - Public
        public private(set) lazy var publisher = createPublisher()
        
        // MARK: - LifeCycle
        public init() {
            monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { [weak self] path in self?.subject.send(path.status) }
            monitor.start(queue: queue)
        }
        deinit {
            monitor.cancel()
            subject.send(completion: .finished)
        }
        
        // MARK: - Private
        private let monitor: NWPathMonitor
        private let queue = DispatchQueue(label: "NetworkMonitor")
        private lazy var subject = CurrentValueSubject<NWPath.Status, Never>(monitor.currentPath.status)
        
        private func createPublisher() -> AnyPublisher<NWPath.Status, Never> {
            return subject.eraseToAnyPublisher()
        }
    }
}
