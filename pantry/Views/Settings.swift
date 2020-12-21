//
//  Settings.swift
//  pantry
//
//  Created by Joris on 23.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI
import os


struct Settings: View {

    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var statusMessage = StatusMessage()

    @State private var showFileImporter = false

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
                                showFileImporter = true
                            }
                        }
                        else if inventories.count == 1 {
                            Button("Export pantry") {
                                if export(inventory: inventories[0]) {
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

        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.directory],
            allowsMultipleSelection: false
        )
        { result in
            var url: [URL]
            do {
                try url = result.get()
            } catch {
                Logger().reportError(error: error)
                return
            }

            if importInventory(url[0], context: managedObjectContext) {
                // All good
            } else {
                statusMessage.error("Failed to import pantry.")
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
