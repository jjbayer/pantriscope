//
//  Inventory.swift
//  pantry
//
//  Created by Joris on 27.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI


struct Inventory: View {

    @ObservedObject var product: Product

    init(product: Product) {
        self.product = product
    }

    var body: some View {
        Text("\(product.expiryDate)")
    }
}
