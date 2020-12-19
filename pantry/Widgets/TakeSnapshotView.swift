//
//  TakeSnapshotView.swift
//  pantry
//
//  Created by Joris on 09.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct TakeSnapshotView: View {

    @Binding var scanProductMode: ScanProductMode
    @Binding var imageData: Data?

    @EnvironmentObject var camera: Camera

    var body: some View {

        ZStack {

            FocusArea(aspectRatio: 1.0, caption: Text("Product photo"))

            GeometryReader { geom in

                let buttonSize = 0.2 * geom.frame(in: .global).width
                VStack(alignment: .center) {
                    Spacer()

                    Image(systemName: "largecircle.fill.circle")
                    .resizable()
                        .frame(maxWidth: buttonSize, maxHeight: buttonSize)
                    .foregroundColor(App.Colors.primary)
                    .padding()
                    .simultaneousGesture(TapGesture().onEnded {
                        imageData = nil
                        camera.takeSnapshot { data in
                            imageData = data
                        }
                        scanProductMode = .scanExpiryDate
                    })
                }.frame(maxWidth: .infinity)
            }
        }
    }
}


struct TakeSnapshotView_Previews: PreviewProvider {
    static var previews: some View {
        TakeSnapshotView(scanProductMode: .constant(.takeSnapshot), imageData: .constant(nil))
    }
}
