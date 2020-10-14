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

        VStack {

            StatusMessageView(statusMessage: $statusMessage)

            Group {

                HStack { Text("Inventory").font(.title); Spacer() }.padding()

                if products.isEmpty {
                    Text("No items in inventory.")
                } else {

                    TextField("Search", text: $searchString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    List {
                        ForEach(products.filter {
                            searchString.isEmpty || $0.detectedText?.lowercased().contains(searchString) ?? false
                        }) { product in
                            HStack {

                                self.photo(product)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 92, height: 92)
                                    .clipped()

                                VStack {
                                    HStack { self.expiryText(product); Spacer() }
                                    HStack { Text("on \(formatDate(product.expiryDate))").font(.footnote).foregroundColor(Color.gray); Spacer() }
                                }

                                Spacer()

                                VStack {
                                    self.archiveButton(product, newState: "consumed", successMessage: "Product consumed.", icon: "checkmark.circle")
                                    .foregroundColor(Color.green)

                                    self.archiveButton(product, newState: "discarded", successMessage: "Product discarded.", icon: "trash.circle")
                                    .foregroundColor(Color.red)
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle()) // Else, entire list item becomes button
                            .modifier(SwipeModifier())

                        }
                    }

                    Spacer()
                }
            }
        }
        .onDisappear {
            statusMessage.clear()
        }
    }

    private func photo(_ product: Product) -> Image {
        if let photoData = product.photo {
            if let uiImage = UIImage(data: photoData) {

                return Image(uiImage: uiImage)
            }
        }

        return Image(systemName: "photo")
    }

    private func expiryText(_ product: Product) -> Text {
        if let expiryDate = product.expiryDate {

            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            formatter.dateTimeStyle = .named

            let today = Calendar.current.startOfDay(for: Date())
            let expiryDay = Calendar.current.startOfDay(for: expiryDate)
            let relativePart = formatter.localizedString(for: expiryDay, relativeTo: today)


            let deltaInDays = today.distance(to: expiryDay) / 3600 / 24

            var color = Color.black
            var text = "expires \(relativePart)"
            if deltaInDays < 0 {
                color = Color.red
                text = "expired \(relativePart)"
            } else if deltaInDays == 0 {
                color = Color.red
                text = "expires today"
            } else if deltaInDays < 4 {
                color = Color.yellow
            }

            return Text(text).foregroundColor(color)

        } else {

            return Text("no expiry date").foregroundColor(Color.gray)
        }
    }

    private func formatDate(_ date: Date?) -> String {

        if let date = date {

            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"

            return df.string(from: date)
        }

        return ""
    }

    private func archiveButton(_ product: Product, newState: String, successMessage: String, icon: String) -> some View {
        return Button(action: {
            product.state = newState
            self.save(successMessage: successMessage, undoAction: { self.restore(product) } )
        }) {
            Image(systemName: icon)

        }
        .frame(minWidth: 64, maxHeight: .infinity)
    }

    private func restore(_ product: Product) {
        product.state = "available"
        save(successMessage: "Product restored.")
    }

    private func save(successMessage: String, undoAction: StatusMessage.UndoAction? = nil) {
        do {
            try self.managedObjectContext.save()
            self.statusMessage.info(successMessage, undoAction: undoAction)
        } catch {
            self.statusMessage.error(error.localizedDescription)
        }
    }



}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
