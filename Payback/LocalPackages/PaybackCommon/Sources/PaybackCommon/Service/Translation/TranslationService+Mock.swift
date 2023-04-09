//
//  TranslationService+Mock.swift
//  Payback
//
//  Created by Pronin Oleksandr on 08.04.23.
//

import Foundation

public struct TranslationServiceMock: TranslationService {
    public init() {}
    public func localizedString(with key: String) -> String { key }
}
