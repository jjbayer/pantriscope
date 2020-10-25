//
//  ProductThumbnail.swift
//  pantry
//
//  Created by Joris on 23.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ProductThumbnail: View {

    var imageData: Data?

    var body: some View {
        self.photo
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70)
            .clipShape(Capsule())
            .foregroundColor(App.Colors.note)
            .padding(10)
    }

    private var photo: Image {
        if let photoData = imageData {
            if let uiImage = UIImage(data: photoData) {

                return Image(uiImage: uiImage)
            }
        }

        return Image(systemName: "photo")
    }
}

struct ProductThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        ProductThumbnail(imageData: nil)
    }
}
