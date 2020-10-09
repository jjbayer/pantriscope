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
            VStack {
                StatusMessageView()

                Spacer()

                if scanProductMode == .takeSnapshot {
                    TakeSnapshotView(scanProductMode: $scanProductMode)
                } else {
                    ScanExpiryDate(scanProductMode: $scanProductMode)
                }
            }
        }
    }

    private func saveSnapshot() {
//        scanProductMode = .scanExpiryDate
//        if let sed = self.scanExpiryDate {
//            self.cameraView.takeSnapshot(delegate: sed.captureHandler)
//        }
    }
    
}

struct ScanProduct_Previews: PreviewProvider {
    static var previews: some View {
        ScanProduct()
    }
}
