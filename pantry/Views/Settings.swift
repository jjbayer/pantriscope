//
//  Settings.swift
//  pantry
//
//  Created by Joris on 23.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Inventory")) {
                    NavigationLink(
                        destination: ArchivedProducts(),
                        label: {
                            Text("View archived products")
                        })
                }
            }
            .navigationBarTitle(Text("Settings"))
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
