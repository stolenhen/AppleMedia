//
//  View+Extension.swift
//  AppleMedia
//
//  Created by Iashes Ivan on 16.05.2022.
//

import SwiftUI

extension View {
    func padding(_ edges: Edge.Set = .all, spacing: Spacing) -> some View {
        padding(edges, spacing.value)
    }

    func errorAlert(errorState: Binding<ErrorState>, retry: (() -> Void)? = nil, cancel: (() -> Void)? = nil) -> some View {
        self.modifier(ErrorAlert(errorState: errorState, retry: retry, cancel: cancel))
    }
}
