//
//  ErrorState.swift
//  AppleMedia
//
//  Created by Iashes Ivan on 04.05.2022.
//

import SwiftUI

struct ErrorState {
    var isError: Bool
    let descriptor: AlertDescriptor
    
    init(isError: Bool, descriptor: AlertDescriptor?) {
        self.isError = isError
        self.descriptor = descriptor ?? .init(title: "", description: "")
    }
}

struct AlertDescriptor {
    let title: String
    let description: String
}

struct ErrorAlert: ViewModifier {
    @Binding var errorState: ErrorState
    
    let retry: (() -> Void)?
    let cancel: (() -> Void)?
    
    func body(content: Content) -> some View {
        content.alert(isPresented: $errorState.isError) {
            Alert(
                title: Text(errorState.descriptor.title),
                message: Text(errorState.descriptor.description),
                primaryButton: .default(Text("Retry")) {
                    (retry ?? {})()
                },
                secondaryButton: .cancel {
                    (cancel ?? {})()
                }
            )
        }
    }
}
