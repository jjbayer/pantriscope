//
//  App.swift
//  pantry
//
//  Created by Joris on 17.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI


// from https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}


struct App {

    struct Colors {
        static let warning = Color(hex: 0xDBD56E)
        static let success = Color(hex: 0x87AA74)
        static let info    = Color(hex: 0x2D93AD)
        static let note    = Color(hex: 0x7D7C84)
        static let error   = Color(hex: 0xDE8F6E)
    }

}
