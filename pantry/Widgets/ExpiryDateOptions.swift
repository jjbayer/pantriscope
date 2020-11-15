//
//  SwiftUIView.swift
//  pantry
//
//  Created by Joris on 09.11.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ExpiryDateOptions: View {
    var body: some View {

        VStack {

            HStack(alignment: .center) {

                ExpiryDateOptionsButton(
                    icon: "chevron.right.2",
                    size: 50,
                    color: App.Colors.note
                ) {

                }

                ExpiryDateOptionsButton(
                    icon: "plus",
                    size: 70,
                    color: App.Colors.primary
                ) {

                }

                ExpiryDateOptionsButton(
                    icon: "calendar",
                    size: 50,
                    color: App.Colors.secondary
                ) {

                }
            }

            HStack {
                Text("no expiry date").frame(maxWidth: .infinity)
                Text("save product").frame(maxWidth: .infinity)
                Text("pick date").frame(maxWidth: .infinity)
            }
            .multilineTextAlignment(.center)
            .font(.footnote)
            .foregroundColor(App.Colors.note)

        }
    }
}


struct ExpiryDateOptionsButton: View {
    let icon: String
    let size: CGFloat
    let color: Color
    let action: () -> ()

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
        }
        .foregroundColor(.white)
        .frame(minWidth: size, minHeight: size)
        .background(color)
        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        .font(.title)
        .frame(maxWidth: .infinity)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ExpiryDateOptions()
            .previewLayout(.sizeThatFits)
            .environment(\.locale, .init(identifier: "de"))
    }
}
