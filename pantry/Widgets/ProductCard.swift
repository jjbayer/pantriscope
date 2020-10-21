//
//  ProductCard.swift
//  pantry
//
//  Created by Joris on 15.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI

struct ProductCard: View {

    let product: Product
    @Binding var statusMessage: StatusMessage

    @Environment(\.managedObjectContext) var managedObjectContext

    @EnvironmentObject var navigator: Navigator

    @State private var delta: (String, TimeInterval)?


    @Binding var detail: Product?

    var body: some View {

        VStack {
            HStack {

                self.photo(product)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Capsule())
                    .padding()


                VStack {
                    self.expiryText
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let date = product.expiryDate {
                        Text("on \(formatDate(date))")
                            .font(.footnote)
                            .foregroundColor(App.Colors.note)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                Spacer()

                Image(systemName: "exclamationmark.circle").foregroundColor(self.warningColor).padding()
            }
            .background(backgroundColor)
            .modifier(
                SwipeModifier(
                    leftAction: { self.archive(newState: "discarded", successMessage: "Product discarded.")},
                    rightAction: { self.archive(newState: "consumed", successMessage: "Product consumed.")}
                )
            )
            .onTapGesture {
                detail = self.product
            }
        }
        .onAppear {
            // Make sure relative dates are fresh:
            self.delta = computeDelta()
        }
        .id(product.id?.uuidString)
    }

    private var backgroundColor: Color {

        if navigator.selectedProductID == product.id?.uuidString {

            return App.Colors.background
        }

        return Color.white
    }

    private func photo(_ product: Product) -> Image {
        if let photoData = product.photo {
            if let uiImage = UIImage(data: photoData) {

                return Image(uiImage: uiImage)
            }
        }

        return Image(systemName: "photo")
    }

    private func computeDelta() -> (String, TimeInterval)? {
        if let expiryDate = product.expiryDate {

            return (
                relativeDateDescription(expiryDate),
                today().distance(to: normalize(expiryDate)) / 3600 / 24)
        }

        return nil
    }

    private var expiryText: Text {
        if let expiryString = product.expiryString {

            return Text(expiryString)
        }

        return Text("no expiry date")
    }

    private var warningColor: Color {
        if let (_, deltaInDays) = delta {
            if deltaInDays < 0 {
                return App.Colors.error
            } else if deltaInDays < 4 {
                return App.Colors.warning
            }
        }

        return Color(white: 1, opacity: 0)
    }

    private func formatDate(_ date: Date?) -> String {

        if let date = date {

            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"

            return df.string(from: date)
        }

        return ""
    }

    private func archive(newState: String, successMessage: String) {
        product.state = newState
        self.save(successMessage: successMessage, undoAction: { self.restore(product) } )
    }

    private func restore(_ product: Product) {
        product.state = "available"
        save(successMessage: "Product restored.")
    }

    private func save(successMessage: String, undoAction: StatusMessage.UndoAction? = nil) {
        do {
            try self.managedObjectContext.save()
            self.statusMessage.info(successMessage, undoAction: undoAction)

            Notifier.instance.requestAuthorization()

        } catch {
            self.statusMessage.error(error.localizedDescription)
        }
    }
}
