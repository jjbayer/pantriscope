//
//  InventoryView.swift
//  pantry
//
//  Created by Joris on 29.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import CoreData
import SwiftUI

struct InventoryView: View {


    @Environment(\.managedObjectContext) var managedObjectContext

    @EnvironmentObject var navigator: Navigator

    @State private var statusMessage = StatusMessage()

    @State var showSearchField = false
    @State private var searchString = ""

    @State private var score: Int? = nil

    @State private var scrollOffset = CGFloat(0.0)

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
        ZStack(alignment: .top) {

            NavigationView {
                ZStack {

                    listView

                    .navigationBarTitle(Text("Pantry"), displayMode: .automatic)

                    ScoreBadge(score: $score)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .offset(x: 0, y: -95)
                }
            }

            StatusMessageView(statusMessage: statusMessage)
        }
        .onAppear { computeScore() }
        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: managedObjectContext)) { value in
            computeScore()
        }
    }

    func computeScore() {
        let request = NSFetchRequest<Product>()
        request.entity = Product.entity()
        request.predicate = NSPredicate(format: "state = 'consumed'")
        if let consumedCount = try? managedObjectContext.count(for: request) {
            request.predicate = NSPredicate(format: "state != 'available'")
            if let archivedCount = try? managedObjectContext.count(for: request) {
                if archivedCount == 0 {
                    score = nil
                } else {
                    score = Int(100*Double(consumedCount) / Double(archivedCount))
                }
            }
        }
    }

    var listView: some View {

        ScrollViewReader { proxy in
            if products.isEmpty {

                Text("No items in pantry.")

            } else {

                List {

                    SearchField(searchString: $searchString)
                        .padding(
                            EdgeInsets(top: 0.0, leading: 15, bottom: 0, trailing: 0)
                        )
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .buttonStyle(PlainButtonStyle())


                    ForEach(products.filter {
                        searchString.isEmpty || $0.detectedText?.lowercased().contains(searchString.lowercased()) ?? false
                    }, id: \.id) { product in
                        ProductCard(product: product, statusMessage: $statusMessage, withDemoAnimation: products.count == 1)
                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))

                }
                .onAppear {
                    scrollToSelected(proxy)
                }
                .listStyle(PlainListStyle())
                .onReceive(navigator.objectWillChange) {
                    scrollToSelected(proxy)
                }
            }
        }
    }

    func scrollToSelected(_ proxy: ScrollViewProxy) {
        let productID = navigator.selectedProductID
        if !productID.isEmpty {
            proxy.scrollTo(productID)
        }
    }
}

struct InventoryView_Previews: PreviewProvider {

    static var previews: some View {
        Preview()
    }

    struct Preview: View {
        @State private var showSearch = false
        @State var searchString = ""

        var body: some View {
                inner



        }

        var inner: some View {
            NavigationView {
                VStack {

                    if showSearch {
                        TextField("Search", text: $searchString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                    }

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
                            .modifier(SwipeModifier(leftAction: {}, rightAction: {}, withDemoAnimation: false))
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                    }
                    .listStyle(PlainListStyle())
                    .environment(\.locale, .init(identifier: "de"))
                    .navigationBarTitle(
                        Text("Pantry"),
                        displayMode: showSearch ? .inline : .automatic
                    )
                    .toolbar(content: {
                        ToolbarItem {
                            Button("search") {
                                showSearch = !showSearch
                            }
                        }
                    })
                }
            }
        }
    }
}
