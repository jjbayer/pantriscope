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

    var body: some View {
        HStack {
            Spacer()
            HStack {
                Image(systemName: "photo")
                Text("Take Snapshot")
            }

            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(20)
            .padding()
            .simultaneousGesture(TapGesture().onEnded {
                Camera.instance.takeSnapshot()
                scanProductMode = .scanExpiryDate
            }
        )
    //                    self.cameraView.takeSnapshot(delegate: self.scanExpiryDate.captureHandler)

            Spacer()
        }
        //                }
    }
}

