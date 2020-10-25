//
//  ScoreBadge.swift
//  pantry
//
//  Created by Joris on 25.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ScoreBadge: View {

    @State var ratio: Double

    var body: some View {
        VStack {
            ZStack {
                Rectangle().foregroundColor(color)
                Text("\(Int(100 * ratio))").font(.title).bold().foregroundColor(.white)
            }
            .frame(maxWidth: 70, maxHeight: 70)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)

            Text("food score").font(.footnote).foregroundColor(color)
        }
    }

    var color: Color {
        if ratio < 0.5 {

            return App.Colors.error
        }
        if ratio < 0.65 {

            return App.Colors.warning
        }

        if ratio < 0.8 {

            return App.Colors.note
        }

        return App.Colors.primary
    }
}

struct ScoreBadge_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBadge(ratio: 1.0).previewLayout(.sizeThatFits)
        ScoreBadge(ratio: 0.65).previewLayout(.sizeThatFits)
        ScoreBadge(ratio: 0.5).previewLayout(.sizeThatFits)
        ScoreBadge(ratio: 0.0).previewLayout(.sizeThatFits)
    }
}
