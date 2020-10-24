//
//  InventoryView.swift
//  pantry
//
//  Created by Joris on 29.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct InventoryView: View {


    @Environment(\.managedObjectContext) var managedObjectContext

    @EnvironmentObject var navigator: Navigator

    @State private var statusMessage = StatusMessage()

    @State private var searchString = ""

    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [
            NSSortDescriptor(key: "expiryDate", ascending: true)
        ],
        predicate: NSPredicate(format: "state like 'available'")
    )
    var products: FetchedResults<Product>

    let currentDate = Date()

    var body: some View {
        NavigationView {
            listView
        }
        .navigationBarTitle(Text("Inventory"))
    }

    var listView: some View {

        VStack {

            StatusMessageView(statusMessage: $statusMessage)

            Text("Inventory").font(.title).padding()

            if products.isEmpty {
                Text("No items in inventory.")
            } else {
                ScrollViewReader { proxy in
                    List {

                        TextField("Search", text: $searchString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        ForEach(products.filter {
                            searchString.isEmpty || $0.detectedText?.lowercased().contains(searchString) ?? false
                        }) { product in
                            ProductCard(product: product, statusMessage: $statusMessage)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                    }
                    .onReceive(navigator.objectWillChange) {
                        let productID = navigator.selectedProductID
                        print("navigator will change, productID = '\(productID)'")
                        if !productID.isEmpty {
                            proxy.scrollTo(productID)
                        }
                    }
                }
            }
        }
    }
}

struct InventoryView_Previews: PreviewProvider {



    static var previews: some View {

            NavigationView {
                List {

                    ForEach(0..<2) { i in

                        ZStack {
                            NavigationLink(destination: Text("f")) {
                                Rectangle()
                            }.opacity(0.0)


                            HStack {

                                ProductThumbnail(imageData: nil)
                                
                                VStack {
                                    Text("Expires in \(i) days")
                                    Text("Added 2020-12-31").font(.footnote)
                                }
                                Spacer()
                                Image(systemName: "circle")
                                    .foregroundColor(App.Colors.warning)
                            }
                        }
                        .background(Color.white)
                        .modifier(SwipeModifier(leftAction: {}, rightAction: {}))

                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                }

                .environment(\.locale, .init(identifier: "de"))
                .navigationBarTitle(Text("Inventory"))
            }

    }
}
