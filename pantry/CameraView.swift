//
//  CameraView.swift
//  pantry
//
//  Created by Joris on 21.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct CameraView: View {
    
    @State private var image = UIImage()
    @State private var doShow = false
    
    var body: some View {
        VStack {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.green)
                .edgesIgnoringSafeArea(.all)
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
        .sheet(isPresented: $doShow) {
            ImagePicker(selectedImage: self.$image)
        }
    }
    
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
