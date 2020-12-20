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

    static let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String

    struct Colors {
        // https://coolors.co/48a9a6-4281a4-93b0bf-e4dfda-d4b483-c1666b
        static let warning = Color(hex: 0xD4B483)
        static let primary = Color(hex: 0x48A9A6)
        static let secondary    = Color(hex: 0x4281A4)
        static let error   = Color(hex: 0xC1666B)
        static let note    = Color(hex: 0x93B0BF)
//        static let background = Color(hex: 0xE4DFDA) // original from coolors
        static let background = Color(hex: 0xe2f3f2)
    }

}
