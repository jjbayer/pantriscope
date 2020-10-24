//
//  StatusMessageView.swift
//  pantry
//
//  Created by Joris on 30.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct StatusMessageView: View {

    @Binding var statusMessage: StatusMessage

    var body: some View {
        HStack {
            Text(message())
            if statusMessage.undoAction != nil {
                Button(action: statusMessage.undoAction!) {
                    Text("Undo").underline()
                }
            }
        }

        .frame(
            minWidth: 0, maxWidth: .infinity,
            minHeight: statusMessage.text == nil ? 0 : 32)
        .background(color())
        .foregroundColor(.white)
        .onAppear {
            statusMessage.clear()
        }

    }

    private func message() -> String {
        if let text = statusMessage.text {
            return text
        }

        return ""
    }

    private func color() -> Color {

        if statusMessage.text == nil {

            return Color(white: 1.0, opacity: 0.0)
        }

        switch statusMessage.status {
            case .debug: return App.Colors.background
            case .success: return App.Colors.primary
            case .warning: return App.Colors.warning
            case .error: return App.Colors.error
        }
    }
}
