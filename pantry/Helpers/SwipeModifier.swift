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

    enum Direction {
        case left2right
        case right2left
    }

    static let minSwipe = CGFloat(100.0)

    var leftAction: () -> ()
    var rightAction: () -> ()

    @State private var contentOffset = CGSize(width: 0, height: 0)
    @State private var direction = Direction.left2right
    @State private var isActive = false // perform action on release

    public func body(content: Content) -> some View {

        ZStack {

            if direction == .left2right {
                SwipeField(alignment: .leading, text: "eat", color: .green, icon: Image(systemName: "mouth"), isActive: $isActive)
            } else {
                SwipeField(alignment: .trailing, text: "throw away", color: .red, icon: Image(systemName: "trash"), isActive: $isActive)
            }

            content
                .background(Color.white)
                .offset(self.contentOffset)
        }
        .onTapGesture {} // Makes scrolling in list possible
        .gesture(gesture)

    }

    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                print("dragging...")
                self.contentOffset.width = value.translation.width
                self.direction = value.translation.width > 0 ? .left2right : .right2left
                isActive = abs(value.translation.width) > SwipeModifier.minSwipe
            }
            .onEnded { _ in
                print("stop dragging")
                withAnimation {
                    self.contentOffset.width = 0
                }

                if isActive {
                    if direction == .left2right {
                        rightAction()
                    } else {
                        leftAction()
                    }
                }

                isActive = false
            }
    }
}

struct SwipeField: View {

    let alignment: Alignment
    let text: String
    let color: Color
    let icon: Image

    @Binding var isActive: Bool

    var body: some View {
        VStack {
            icon
            Text(text).bold()
        }
        .padding()
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        .background(isActive ? color : Color.gray)
    }

}
