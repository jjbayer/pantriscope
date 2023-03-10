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


    // Show either camera view or inventory view
    @Published var selectedTabItem: ContentView.TabID = .takeSnapshot

    // Which product to highlight in the list view
    @Published var selectedProductID: String = ""

    @Published var dummy = false
}
