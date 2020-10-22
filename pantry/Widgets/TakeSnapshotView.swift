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
        
        Image(systemName: "largecircle.fill.circle")
            .resizable()
            .frame(maxWidth: 80, maxHeight: 80)
            .foregroundColor(App.Colors.primary)
            .padding()
            .simultaneousGesture(TapGesture().onEnded {
                Camera.instance.takeSnapshot()
                scanProductMode = .scanExpiryDate
            }
        )


        //                }
    }
}

