//
//  FocusArea.swift
//  pantry
//
//  Created by Joris on 15.11.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct FocusArea: View {

    let aspectRatio: CGFloat
    let caption: Text

    private let relViewFinderWidth: CGFloat = 0.9

    var body: some View {
        GeometryReader { geometry in
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(App.Colors.note, lineWidth: 4)
                    .frame(
                        width: relViewFinderWidth * geometry.size.width,
                        height: relViewFinderHeight * geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(App.Colors.note)

                caption.foregroundColor(App.Colors.note)

            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    private var relViewFinderHeight: CGFloat {
        return aspectRatio * relViewFinderWidth
    }
}

struct FocusArea_Previews: PreviewProvider {
    static var previews: some View {
        FocusArea(aspectRatio: 1.0, caption: Text("Hello"))
    }
}
