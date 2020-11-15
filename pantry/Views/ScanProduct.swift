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

    @State var imageData: Data? = nil

    let relViewFinderWidth: CGFloat = 0.9

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraView()
                    .scaledToFill()
                    .layoutPriority(-1) // https://stackoverflow.com/questions/58290963/clip-image-to-square-in-swiftui

                VStack {

                    Spacer()
                    Spacer()

                    RoundedRectangle(cornerRadius: 10)
                        .stroke(App.Colors.note, lineWidth: 4)
                        .frame(
                            width: relViewFinderWidth * geometry.size.width,
                            height: relViewFinderHeight * geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text(scanProductMode == .takeSnapshot ? "Product photo" : "Scan expiry date")
                        .foregroundColor(App.Colors.note)

                if scanProductMode == .takeSnapshot {
                    TakeSnapshotView(scanProductMode: $scanProductMode, imageData: $imageData)
                } else {
                    ScanExpiryDate(scanProductMode: $scanProductMode, statusMessage: $statusMessage, imageData: $imageData)

                    StatusMessageView(statusMessage: statusMessage)

                    Spacer()

                    if scanProductMode == .takeSnapshot {
                        TakeSnapshotView(scanProductMode: $scanProductMode, imageData: $imageData)
                    } else {
                        ScanExpiryDate(scanProductMode: $scanProductMode, statusMessage: $statusMessage, imageData: $imageData)

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

                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(App.Colors.note, lineWidth: 4)
                        .frame(width: 0.9 * geometry.size.width, height: 0.3 * geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("Product photo").foregroundColor(App.Colors.note)
                }

                VStack {
                    StatusMessageView(statusMessage: StatusMessage())
                    Spacer()


                    Image(systemName: "largecircle.fill.circle")
                        .resizable()
                        .frame(maxWidth: 80, maxHeight: 80)
                        .foregroundColor(App.Colors.primary)
                        .padding()
                }

            }
        }
    }
}
