//
//  ContentView.swift
//  pantry
//
//  Created by Joris on 19.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var statusMessage: StatusMessage

    var body: some View {
        TabView {

            ScanProduct()
                .tabItem {
                    Image(systemName: "photo")
                    Text("Scan")
                }
                .tag(0)
                .onAppear {
                    statusMessage.clear()
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
                .onAppear {
                    statusMessage.clear()
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView().environment(\.managedObjectContext, context)

        return contentView
    }
}
