//
//  ImagePicker.swift
//  pantry
//
//  Created by Joris on 21.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            // Hide
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}
