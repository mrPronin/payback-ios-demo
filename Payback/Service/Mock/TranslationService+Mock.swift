//
//  TranslationService+Mock.swift
//  Payback
//
//  Created by Pronin Oleksandr on 08.04.23.
//

import Foundation

struct TranslationServiceMock: TranslationService {
    func localizedString(with key: String) -> String { key }
}
