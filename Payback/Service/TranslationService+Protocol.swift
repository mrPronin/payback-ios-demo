//
//  LocalisedStrings.swift
//  Payback
//
//  Created by Pronin Oleksandr on 07.04.23.
//

import Foundation

public protocol TranslationService {
    func localizedString(with key: String) -> String
}
