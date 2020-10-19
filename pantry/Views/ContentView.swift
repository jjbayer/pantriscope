//
//  ContentView.swift
//  pantry
//
//  Created by Joris on 19.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {

            ScanProduct()
                .tabItem {
                    Image(systemName: "photo")
                    Text("Scan")
                }
                .tag(0)
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
                .tag(1)
        }
        .accentColor(App.Colors.info)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return TabView {

            Text("Scan Product")
                .tabItem {
                    Image(systemName: "photo")
                    Text("Scan")
                }
                .background(App.Colors.background)
                .foregroundColor(App.Colors.info)
                .tag(0)

            Text("Inventory")
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Inventory")
                }
                .tag(1)
        }
        .accentColor(App.Colors.info)
        .foregroundColor(App.Colors.note)
        .background(App.Colors.background)
    }
}
