//
//  CameraView.swift
//  pantry
//
//  Created by Joris on 21.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ScanProduct: View {
    
    @State private var image = UIImage()

    let cameraView = CameraView()
    let scanExpiryDate = ScanExpiryDate()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Scan Product").font(.title)

                StatusMessageView()

                Spacer()

                cameraView

                NavigationLink(destination: scanExpiryDate) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Take Snapshot")
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(20)
                .padding()
                .simultaneousGesture(TapGesture().onEnded {
                    self.cameraView.takeSnapshot(delegate: self.scanExpiryDate.captureHandler)
                })

            }
        }
    }
    
}

struct ScanProduct_Previews: PreviewProvider {
    static var previews: some View {
        ScanProduct()
    }
}
