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
                Image(systemName: "viewfinder")
                Text("Scan Product")
            }

            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            .foregroundColor(.white)
            .background(App.Colors.primary)
            .cornerRadius(10)
            .padding()
            .simultaneousGesture(TapGesture().onEnded {
                Camera.instance.takeSnapshot()
                scanProductMode = .scanExpiryDate
            }
        )


        //                }
    }
}

