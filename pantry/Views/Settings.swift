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

    @State var statusMessage = StatusMessage()

    @State private var showFileImporter = false

    @FetchRequest(
        entity: Inventory.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "name like 'default'")
    )
    var inventories: FetchedResults<Inventory>

    var body: some View {
        ZStack(alignment: .top) {
            NavigationView {
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

                }.navigationBarTitle(Text("Settings"))
            }

            StatusMessageView(statusMessage: statusMessage)
        }

        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.folder],
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

            let exportURL = url[0]
            let _ = exportURL.startAccessingSecurityScopedResource() // obscure, see https://stackoverflow.com/a/64842270
            let success = importInventory(exportURL, context: managedObjectContext)
            exportURL.stopAccessingSecurityScopedResource()

            if success {
                statusMessage.success(NSLocalizedString("Successfully imported pantry.", comment: ""))
            } else {
                statusMessage.error(NSLocalizedString("Failed to import pantry.", comment: ""))
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        settings.statusMessage.success("Success message")

        return settings
    }
}
