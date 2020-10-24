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

    var body: some View {

        VStack {
            HStack {

                ProductThumbnail(imageData: product.photo)

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
                    leftAction: {
                        self.archive(
                            newState: "discarded",
                            successMessage: NSLocalizedString("Product discarded.", comment: "")
                        )
                    },
                    rightAction: { self.archive(newState: "consumed", successMessage: NSLocalizedString("Product consumed.", comment: ""))}
                )
            )
            .onTapGesture {
                navigator.productDetail = self.product
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
        save(successMessage: NSLocalizedString("Product restored.", comment: "when moved back from archive to available products"))
    }

    private func save(successMessage: String, undoAction: StatusMessage.UndoAction? = nil) {
        do {
            try self.managedObjectContext.save()
            self.statusMessage.success(successMessage, undoAction: undoAction)

            Notifier.instance.requestAuthorization()

        } catch {
            self.statusMessage.error(error.localizedDescription)
        }
    }
}
