//
//  ScoreBadge.swift
//  pantry
//
//  Created by Joris on 25.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ScoreBadge: View {

    @Binding var score: Int?
    @State private var shownScore = 0

    var body: some View {
        if score == nil {
            EmptyView()
        } else {
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
            .onAppear {
                if let score = score {
                    shownScore = score
                }
            }
        }
    }

    func slowChange() {
        if shownScore == score { return }
        if let score = score {
            let step = score > shownScore ? 1 : -1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
                shownScore += step
                slowChange()
            }
        }
    }

    var color: Color {
        if shownScore < 60 {

            return App.Colors.error
        }
        if shownScore < 75 {

            return App.Colors.warning
        }

        if shownScore < 90 {

            return App.Colors.note
        }

        return App.Colors.primary
    }
}

struct ScoreBadge_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBadge(score: .constant(100)).previewLayout(.sizeThatFits)
        ScoreBadge(score: .constant(76)).previewLayout(.sizeThatFits)
        ScoreBadge(score: .constant(65)).previewLayout(.sizeThatFits)
        ScoreBadge(score: .constant(50)).previewLayout(.sizeThatFits)
    }
}
