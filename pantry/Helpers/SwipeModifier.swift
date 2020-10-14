//
//  SwipeModifier.swift
//  pantry
//
//  Created by Joris on 14.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import SwiftUI

struct SwipeModifier: AnimatableModifier {

    // based on https://github.com/EnesKaraosman/SwipeCell/blob/master/Sources/SwipeCell/SlidableModifier.swift

    @State private var contentOffset = CGSize(width: 0, height: 0)

    public func body(content: Content) -> some View {

        ZStack {
            content
            .offset(self.contentOffset)
        }
        .gesture(gesture)

    }

    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                print("dragging...")
                self.contentOffset.width = value.translation.width
            }
            .onEnded { _ in
                print("stop dragging")
                withAnimation {
                    self.contentOffset.width = 0
                }
            }
    }
}
