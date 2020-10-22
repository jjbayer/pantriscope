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
    @State private var statusMessage = StatusMessage()

    @State var scanProductMode = ScanProductMode.takeSnapshot

    let relViewFinderWidth: CGFloat = 0.9

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraView()
                    .scaledToFill()
                    .layoutPriority(-1) // https://stackoverflow.com/questions/58290963/clip-image-to-square-in-swiftui

                RoundedRectangle(cornerRadius: 10)
                    .stroke(App.Colors.note, lineWidth: 4)
                    .frame(
                        width: relViewFinderWidth * geometry.size.width,
                        height: relViewFinderHeight * geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                VStack {

                    StatusMessageView(statusMessage: $statusMessage)

                    Spacer()

                    if scanProductMode == .takeSnapshot {
                        TakeSnapshotView(scanProductMode: $scanProductMode)
                    } else {
                        ScanExpiryDate(scanProductMode: $scanProductMode, statusMessage: $statusMessage)

                    }
                }
            }
        }
    }

    private var relViewFinderHeight: CGFloat {
        let aspectRatio = (scanProductMode == .takeSnapshot ? 1.0 : 1.0/3)
        return CGFloat(aspectRatio) * relViewFinderWidth
    }
}

struct ScanProduct_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            ZStack {

                Rectangle().scaledToFill().layoutPriority(-1) // represents camera

                RoundedRectangle(cornerRadius: 20)
                    .stroke(App.Colors.note, lineWidth: 4)
                    .frame(width: 0.9 * geometry.size.width, height: 0.3 * geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                VStack {
                    StatusMessageView(statusMessage: .constant(StatusMessage()))
                    Spacer()


                    Text("Bottom content").foregroundColor(.pink)
                }

            }
        }
    }
}
