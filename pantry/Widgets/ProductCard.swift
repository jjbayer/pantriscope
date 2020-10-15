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

    var body: some View {
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
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Spacer()

            Image(systemName: "circle").foregroundColor(self.warningColor).padding()
        }
        .modifier(
            SwipeModifier(
                leftAction: { self.archive(newState: "discarded", successMessage: "Product discarded.")},
                rightAction: { self.archive(newState: "consumed", successMessage: "Product consumed.")}
            )
        )
    }

    private func photo(_ product: Product) -> Image {
        if let photoData = product.photo {
            if let uiImage = UIImage(data: photoData) {

                return Image(uiImage: uiImage)
            }
        }

        return Image(systemName: "photo")
    }

    private var delta: (String, TimeInterval)? {
        if let expiryDate = product.expiryDate {

            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            formatter.dateTimeStyle = .named

            let today = Calendar.current.startOfDay(for: Date())
            let expiryDay = Calendar.current.startOfDay(for: expiryDate)
            let relativePart = formatter.localizedString(for: expiryDay, relativeTo: today)

            return (relativePart, today.distance(to: expiryDay) / 3600 / 24)



        }

        return nil
    }

    private var expiryText: Text {
        if let (relativePart, deltaInDays) = delta {
            var text = "expires \(relativePart)"
            if deltaInDays < 0 {
                text = "expired \(relativePart)"
            } else if deltaInDays == 0 {
                text = "expires today"
            }

            return Text(text)
        }

        return Text("no expiry date").foregroundColor(Color.gray)
    }

    private var warningColor: Color {
        if let (_, deltaInDays) = delta {
            if deltaInDays < 0 {
                return Color.red
            } else if deltaInDays < 4 {
                return Color.yellow
            }
        }

        return Color.white
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
        } catch {
            self.statusMessage.error(error.localizedDescription)
        }
    }
}

struct ProductCard_Previews: PreviewProvider {

    static let product = Product()

    static var previews: some View {
        ProductCard(product: product, statusMessage: .constant(StatusMessage()))
    }
}
