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
        HStack(alignment: .center) {

            Spacer()

            ExpiryDateOptionsButton(
                icon: "chevron.right.2",
                text: Text("save without expiry date"),
                size: 50,
                color: App.Colors.note
            ) {

            }

            Spacer()

            ExpiryDateOptionsButton(
                icon: "plus",
                text: Text("save product"),
                size: 70,
                color: App.Colors.primary
            ) {

            }

            Spacer()

            ExpiryDateOptionsButton(
                icon: "calendar",
                text: Text("pick a date"),
                size: 50,
                color: App.Colors.secondary
            ) {

            }

            Spacer()

        }
    }
}


struct ExpiryDateOptionsButton: View {
    let icon: String
    let text: Text
    let size: CGFloat
    let color: Color
    let action: () -> ()

    var body: some View {
        return VStack {

            Spacer()

            Button(action: action) {
                Image(systemName: icon)
            }
            .foregroundColor(.white)
            .frame(minWidth: size, minHeight: size)
            .background(color)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .font(.title)

            Spacer()

            text.font(.footnote).foregroundColor(App.Colors.note)
        }
        .frame(maxWidth: 90, maxHeight: 100)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ExpiryDateOptions().previewLayout(.sizeThatFits)
    }
}
