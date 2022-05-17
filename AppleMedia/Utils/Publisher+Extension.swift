//
//  Combine+Extension.swift
//  AppleMedia
//
//  Created by Iashes Ivan on 17.05.2022.
//

import Foundation
import Combine

extension Publisher where Self.Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on obj: Root) -> AnyCancellable {
        sink { [weak obj] in obj?[keyPath: keyPath] = $0 }
    }
}
