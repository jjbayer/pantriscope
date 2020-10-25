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

    @State var showSearchField = false
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
        VStack {
            StatusMessageView(statusMessage: $statusMessage)
            NavigationView {
                VStack {
                    TextField("Search", text: $searchString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    listView

                }
                .navigationBarTitle(Text("Inventory"), displayMode: .automatic)
            }
        }
    }

    var listView: some View {

//            if products.isEmpty {
//                Text("No items in inventory.")
//            } else {
                ScrollViewReader { proxy in
                    List {
                        ForEach(products.filter {
                            searchString.isEmpty || $0.detectedText?.lowercased().contains(searchString) ?? false
                        }) { product in
                            ProductCard(product: product, statusMessage: $statusMessage)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                    }
                    .listStyle(PlainListStyle())
                    .onReceive(navigator.objectWillChange) {
                        let productID = navigator.selectedProductID
                        print("navigator will change, productID = '\(productID)'")
                        if !productID.isEmpty {
                            proxy.scrollTo(productID)
                        }
                    }
                }
            }

//    }
}

struct InventoryView_Previews: PreviewProvider {



    static var previews: some View {
        Preview()
    }

    struct Preview: View {
        @State var searchString = ""

        var body: some View {
            ZStack {
                inner

                VStack {
                    HStack {
                        Spacer()
                        Text("score:").font(.footnote).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        VStack {
                            ZStack {
                                Rectangle().foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                Text("100").font(.title).bold().foregroundColor(.white)
                            }
                            .frame(maxWidth: 70, maxHeight: 70)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        }
                    }
                    Spacer()
                }

                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            }

        }

        var inner: some View {
            NavigationView {
                VStack {
                    TextField("Search", text: $searchString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    ScrollViewReader { info in

                            List {

                                ForEach(0..<20) { i in

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
                                    .modifier(SwipeModifier(leftAction: {}, rightAction: {}))

                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                            }

                    }
                }
                .listStyle(PlainListStyle())
                .environment(\.locale, .init(identifier: "de"))
                .navigationBarTitle(Text("Inventory"), displayMode: .automatic)

            }
        }
    }
}
