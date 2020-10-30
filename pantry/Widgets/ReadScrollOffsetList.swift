//
//  ListReader.swift
//  pantry
//
//  Created by Joris on 28.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI


struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]

    static var defaultValue: [CGFloat] = [0]

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}


struct ReadScrollOffsetList<Content: View>: View {

    @Binding var scrollOffset: CGFloat
    let content: Content

    init(scrollOffset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self._scrollOffset = scrollOffset
        self.content = content()
    }

    var body: some View {

        GeometryReader { outerGeom in
            List {
                ZStack(alignment: .top) {
                    GeometryReader { geom in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: [geom.frame(in: .global).minY - outerGeom.frame(in: .global).minY])
                    }
                    VStack {
                        content
                    }
                }
            }
        }

        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value[0]
        }
    }
}

struct ListReader_Previews: PreviewProvider {

    struct Preview: View {

        @State private var scrollOffset = CGFloat(0.0)

        var body: some View {
            ReadScrollOffsetList(scrollOffset: $scrollOffset) {
                Text("Scroll offset: \(scrollOffset)")
                ForEach(0..<10) { i in
                    Text("Item \(i)")
                }
            }
            .listStyle(PlainListStyle())
            .listRowInsets(.none)
        }
    }

    static var previews: some View {
        Preview()
    }
}
