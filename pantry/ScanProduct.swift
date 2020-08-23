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
    @State private var doShow = false
    
    var body: some View {
        VStack {
            CameraView()
            Button(action: { self.doShow = true }) {
                HStack {
                    Image(systemName: "photo")
                    Text("Take Snapshot")
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .foregroundColor(.white)
                .background(Color.blue)
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
