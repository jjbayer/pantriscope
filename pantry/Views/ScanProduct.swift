//
//  CameraView.swift
//  pantry
//
//  Created by Joris on 21.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

enum ScanProductMode {
    case takeSnapshot
    case scanExpiryDate
}

struct ScanProduct: View {
    
    @State private var image = UIImage()

    @State var scanProductMode = ScanProductMode.takeSnapshot

    var body: some View {
        ZStack {
            CameraView()
                .scaledToFill()
                .layoutPriority(-1) // https://stackoverflow.com/questions/58290963/clip-image-to-square-in-swiftui
            VStack {
                StatusMessageView()

                Spacer()

                if scanProductMode == .takeSnapshot {
                    TakeSnapshotView(scanProductMode: $scanProductMode)
                } else {
                    ScanExpiryDate(scanProductMode: $scanProductMode)
                        .onAppear {
                            print("expdate appear")
                            Camera.instance.onFrame {
                                print("Got frame")
                            }
                        }
                        .onDisappear {
                            print("expdate gone")
                            Camera.instance.clearFrameHandler()
                        }
                }
            }
        }
    }
}

struct ScanProduct_Previews: PreviewProvider {
    static var previews: some View {
        ScanProduct()
    }
}
