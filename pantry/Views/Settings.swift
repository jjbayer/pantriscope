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
                .navigationBarTitle(Text("Settings"))
            }

            StatusMessageView(statusMessage: statusMessage)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
