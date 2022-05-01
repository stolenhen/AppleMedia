//
//  Presenter.swift
//  AppleMedia
//
//  Created by stolenhen on 02.12.2020.
//

import SwiftUI

enum Presenter: Identifiable {
    case alert(_ type: AlertType)
    
    var id: String { UUID().uuidString }
    
    enum AlertType {
        case error(description: AppleMediaErrors)
        case warning(message: String)
        case warningWithAction(message: String, action: (() -> Void))
    }
}

struct AlertPresenter: ViewModifier {
    
    @Binding var presenter: Presenter?
    
    func body(content: Content) -> some View {
        switch presenter {
        case let .alert(.error(description)):
            return
                content.alert(item: $presenter)  {_ in
                    Alert(
                        title: Text("Warning"),
                        message: Text(description.localizedDescription),
                        dismissButton: .destructive(Text("Ok")
                        )
                    )
                }
                .anyView
            
        case let .alert(.warning(message)):
            return
                content.alert(item: $presenter)  {_ in
                    Alert(
                        title: Text(""),
                        message: Text(message),
                        dismissButton: .destructive(Text("Ok")
                        )
                    )
                }
                .anyView
            
        case let .alert(.warningWithAction(message: message, action: action)):
        return
            content.alert(item: $presenter) {_ in
                Alert(
                    title: Text("Warning"),
                    message: Text(message),
                    primaryButton: .default(Text("Ok"), action: action),
                    secondaryButton: .destructive(Text("Cancel")
                    )
                )
            }
            .anyView
            
        case .none:
            return
                content.anyView
        }
    }
}
