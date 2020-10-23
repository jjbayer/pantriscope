//
//  ProductThumbnail.swift
//  pantry
//
//  Created by Joris on 23.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ProductThumbnail: View {

    var product: Product

    var body: some View {
        self.photo
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .clipShape(Capsule())
            .padding()
    }

    private var photo: Image {
        if let photoData = product.photo {
            if let uiImage = UIImage(data: photoData) {

                return Image(uiImage: uiImage)
            }
        }

        return Image(systemName: "photo")
    }
}

struct ProductThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        ProductThumbnail(product: Product())
    }
}
