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
                SwipeField(alignment: .leading, text: Text("consumed"), color: App.Colors.primary, icon: Image(systemName: "leaf.arrow.triangle.circlepath"), isActive: $isActive, contentOffset: $contentOffset).opacity(contentOffset.width == 0 ? 0.0: 1.0)
            } else {
                SwipeField(alignment: .trailing, text: Text("discarded"), color: App.Colors.warning, icon: Image(systemName: "trash"), isActive: $isActive, contentOffset: $contentOffset).opacity(contentOffset.width == 0 ? 0.0: 1.0)
            }

            content
                .offset(self.contentOffset)
        }
        .gesture(gesture)
    }

    private var gesture: some Gesture {
        DragGesture(minimumDistance: 50, coordinateSpace: .local)
            .onChanged { value in
                print("changed")
                self.contentOffset.width = value.translation.width
                self.direction = value.translation.width > 0 ? .left2right : .right2left
                isActive = abs(value.translation.width) > SwipeModifier.minSwipe
            }
            .onEnded { _ in
                print("ended")
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
    let text: Text
    let color: Color
    let icon: Image

    @Binding var isActive: Bool
    @Binding var contentOffset: CGSize

    var body: some View {
        HStack {

            if contentOffset.width < 0 { Spacer() }

            VStack {
                if abs(contentOffset.width) > SwipeModifier.minSwipe {
                    icon
                    text
                } else {
                    EmptyView()
                }
            }
            .frame(maxWidth: abs(contentOffset.width), maxHeight: .infinity)
            .foregroundColor(Color.white)
            .background(color)

            if contentOffset.width > 0 { Spacer() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }

}

struct SwipeModifier_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ForEach(0..<20) { i in
                Text("Item \(i)")
                    .frame(maxWidth: .infinity,maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .modifier(SwipeModifier(leftAction: {}, rightAction: {}))
            }
        }
    }
}
