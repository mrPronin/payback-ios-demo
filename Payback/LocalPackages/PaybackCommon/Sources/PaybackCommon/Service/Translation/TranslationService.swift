//
//  TranslationService.swift
//  
//
//  Created by Pronin Oleksandr on 09.04.23.
//

import Foundation

public extension Translation {
    struct Service: TranslationService {
        public init() {}
        public func localizedString(with key: String) -> String {
            /*
             In the future, it will be possible to download a file with localized thongs from a secure repository and be able to change it without publishing a new release.
            */
            NSLocalizedString(key, bundle: .module, comment: "")
        }
    }
}

public extension String {
    var localized: String {
        NSLocalizedString(self, bundle: .module, comment: "")
    }
    func localized(with argument: String) -> String {
        return String.localizedStringWithFormat(NSLocalizedString(self, bundle: .module, comment: ""), "\(argument)")
    }
}
