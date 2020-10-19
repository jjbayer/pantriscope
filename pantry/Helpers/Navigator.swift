//
//  Navigator.swift
//  pantry
//
//  Created by Joris on 19.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import Foundation

class Navigator: ObservableObject {

    static var instance = Navigator()

    @Published var selectedTabItem: ContentView.TabID = .takeSnapshot

    @Published var selectedProductID: String = ""
}
