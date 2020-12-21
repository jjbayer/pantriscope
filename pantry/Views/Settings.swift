//
//  Settings.swift
//  pantry
//
//  Created by Joris on 23.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct Settings: View {

    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var statusMessage = StatusMessage()

    @FetchRequest(
        entity: Inventory.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "name like 'default'")
    )
    var inventories: FetchedResults<Inventory>

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Form {
                    Section(header: Text("Pantry")) {
                        NavigationLink(
                            destination: ArchivedProducts(),
                            label: {
                                Text("View archived products")
                            })

                        if inventories.isEmpty {
                            Button("Import pantry") {

                            }
                        }

                        Button("Export pantry") {
                            if let inventory = Inventory.defaultInventory(managedObjectContext) {
                                if export(inventory: inventory) {
                                    // All good
                                } else {
                                    statusMessage.error("Failed to export pantry.")
                                }
                            }
                        }
                    }
                }
                StatusMessageView(statusMessage: statusMessage)
            }
        }.navigationBarTitle(Text("Settings"))
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
