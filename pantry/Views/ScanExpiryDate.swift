//
//  CameraView.swift
//  pantry
//
//  Created by Joris on 21.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI
import AVFoundation

class CaptureHandler: NSObject, AVCapturePhotoCaptureDelegate, ObservableObject {

    @Published var data: Data?

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        self.data = photo.fileDataRepresentation()
    }

}

struct ScanExpiryDate: View {

    // I would prefer to bind to Core Data object directly, but I haven't figured
    // out how to handle optional bindings yet
    @State private var hasExpiryDate = true
    @State private var expiryDate = Date()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var statusMessage: StatusMessage
    @ObservedObject var captureHandler = CaptureHandler()

    var body: some View {
//        NavigationView {
        ZStack {
//            CameraView()
            VStack {
                Text("Scan Expiry Date")
                    .font(.title)


                StatusMessageView()

                Spacer()

                if hasExpiryDate {
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                    .labelsHidden()
                }


                Toggle(isOn: $hasExpiryDate) {
                    Text("product has expiry date")
                }
                .padding()

                Button(action: {

                    let product = Product(context: self.managedObjectContext)
                    product.id = UUID()
                    if let data = self.captureHandler.data {
                        product.photo = data
                    }
                    if self.hasExpiryDate {
                        product.expiryDate = self.expiryDate
                    }

                    do {
                        try self.managedObjectContext.save()
                        self.statusMessage.message = "Order saved."
                    } catch {
                        self.statusMessage.message = error.localizedDescription
                    }
                    // Back to product scan
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add Product")
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(20)
                .padding()

            }
        }
//        }
    }

}

struct ScanExpiryDate_Previews: PreviewProvider {
    static var previews: some View {
        ScanExpiryDate()
    }
}
