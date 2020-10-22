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
                .onAppear {
                    Camera.instance.start()
                }
                .onDisappear {
                    Camera.instance.stop()
                }

            InventoryView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Inventory")
                }
                .tag(TabID.inventory)
                .onDisappear {
                    // No need to show it anymore
                    navigator.selectedProductID = ""
                }
        }
        .accentColor(App.Colors.primary)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return TabView {

            Text("Scan Product")
                .tabItem {
                    Image(systemName: "viewfinder")
                    Text("Add products")
                }
                .background(App.Colors.background)
                .foregroundColor(App.Colors.primary)
                .tag(0)

            Text("Inventory")
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Inventory")
                }
                .tag(1)
        }
        .accentColor(App.Colors.primary)
        .foregroundColor(App.Colors.note)
        .background(App.Colors.background)
    }
}
