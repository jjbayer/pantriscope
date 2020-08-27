//
//  Product.swift
//  pantry
//
//  Created by Joris on 27.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import SwiftUI


class Product: ObservableObject {
    @Published var expiryDate = Date()
    @Published var hasExpiryDate = true
}
