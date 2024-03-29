//
//  URLSession+publisher.swift
//  Payback
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation
import Combine

public extension URLSession {
    func publisher<Kind, Response, Payload>(
        for endpoint: Endpoint<Kind, Response, Payload>,
        using requestData: Kind.RequestData? = nil,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Response, Error> {
        guard let request = endpoint.makeRequest(with: requestData) else {
            return Fail(error: Network.Errors.invalidURL).eraseToAnyPublisher()
        }
        return dataTaskPublisher(for: request)
            .tryMap({ data, response in
                // If the response is invalid, throw an error
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw Network.error(from: response.statusCode)
                }
                // Return Response data
                return data
            })
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError { Network.handleError($0) }
            .eraseToAnyPublisher()
    }
}
