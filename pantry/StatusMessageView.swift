//
//  StatusMessageView.swift
//  pantry
//
//  Created by Joris on 30.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct StatusMessageView: View {

    @EnvironmentObject var statusMessage: StatusMessage

    var body: some View {
        Text(message())
            .frame(
                minWidth: 0, maxWidth: .infinity,
                minHeight: 32)
            .background(color())
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)

    }

    private func message() -> String {
        if let text = statusMessage.message {
            return text
        }

        return ""
    }

    private func color() -> Color {
        switch statusMessage.status {
            case .debug: return Color.gray
            case .info: return Color.blue
            case .warning: return Color.yellow
            case .error: return Color.red
        }
    }
}

struct StatusMessageView_Previews: PreviewProvider {
    static var previews: some View {
        StatusMessageView()
    }
}
