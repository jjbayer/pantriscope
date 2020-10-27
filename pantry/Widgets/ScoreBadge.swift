//
//  ScoreBadge.swift
//  pantry
//
//  Created by Joris on 25.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ScoreBadge: View {

    @State var score: Int = 0
    @State private var shownScore = 0

    init(score: Int) {
        self.score = score
        shownScore = score
    }

    var body: some View {
        VStack {
            ZStack {
                Rectangle().foregroundColor(color)
                Text("\(shownScore)").font(.title).bold().foregroundColor(.white)
            }
            .frame(maxWidth: 70, maxHeight: 70)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)

            Text("% saved").font(.footnote).foregroundColor(color)

        }
        .onChange(of: score, perform: { value in
            slowChange()
        })
    }

    func slowChange() {
        if shownScore == score { return }
        let step = score > shownScore ? 1 : -1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            shownScore += step
            slowChange()
        }
    }

    var color: Color {
        if shownScore < 50 {

            return App.Colors.error
        }
        if shownScore < 65 {

            return App.Colors.warning
        }

        if shownScore < 80 {

            return App.Colors.note
        }

        return App.Colors.primary
    }
}

struct ScoreBadge_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBadge(score: 100).previewLayout(.sizeThatFits)
        ScoreBadge(score: 65).previewLayout(.sizeThatFits)
        ScoreBadge(score: 50).previewLayout(.sizeThatFits)
        ScoreBadge(score: 0).previewLayout(.sizeThatFits)
    }
}
