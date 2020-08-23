//
//  CameraView.swift
//  pantry
//
//  Created by Joris on 21.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ScanExpiryDate: View {

    @State private var image = UIImage()
    @State private var doShow = false

    var body: some View {
        VStack {
            Text("Scan Expiry Date")
            //CameraView()
            Button(
                action: {
                    self.doShow = true

                }
            ) {
                HStack {
                    Image(systemName: "photo")
                    Text("Scan expiry date")
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(20)
                .padding(.horizontal)
            }

        }
    }

}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        ScanProduct()
    }
}
