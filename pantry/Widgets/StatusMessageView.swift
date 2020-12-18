//
//  StatusMessageView.swift
//  pantry
//
//  Created by Joris on 30.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

// Animation based on https://trailingclosure.com/notification-banner-using-swiftui/
struct StatusMessageView: View {

    @ObservedObject var statusMessage: StatusMessage

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
            maxHeight: statusMessage.text == nil ? 0 : 32)
        .background(color())
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
        .foregroundColor(.white)
        .animation(.easeInOut)
        .transition(AnyTransition.move(edge: .top))

    }

    private func message() -> String {
        if let text = statusMessage.text {
            return text
        }

        return ""
    }

    private func color() -> Color {

        if statusMessage.text == nil {

            return Color.clear
        }

        switch statusMessage.status {
            case .debug: return App.Colors.background
            case .success: return App.Colors.primary
            case .warning: return App.Colors.warning
            case .error: return App.Colors.error
        }
    }
}

struct StatusMessageView_Previews: PreviewProvider {

    struct Preview: View {

        private var sm = StatusMessage()

        init() {
            sm.success("Success message")
        }

        var body: some View {
            StatusMessageView(statusMessage: sm)
        }
    }

    static var previews: some View {
        Preview()
    }
}
