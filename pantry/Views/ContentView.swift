//
//  ContentView.swift
//  pantry
//
//  Created by Joris on 19.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    enum TabID {
        case takeSnapshot
        case inventory
        case settings
    }

    @EnvironmentObject var navigator: Navigator

    var body: some View {
        TabView(selection: $navigator.selectedTabItem) {

            ScanProduct()
                .tabItem {
                    Image(systemName: "viewfinder")
                    Text("Add products")
                }
                .tag(TabID.takeSnapshot)

            InventoryView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Pantry")
                }
                .tag(TabID.inventory)
                .onDisappear {
                    // No need to show it anymore
                    navigator.selectedProductID = ""
                }

            Settings()
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver")
                    Text("Extras")
                }
                .tag(TabID.settings)
        }
        .accentColor(App.Colors.primary)
    }
}


