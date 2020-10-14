//
//  Vision.swift
//  pantry
//
//  Created by Joris on 12.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import AVFoundation
import MLKit
//import UIUtilities


func detectExpiryDate(sampleBuffer: CMSampleBuffer, onSuccess: @escaping (ParsedExpiryDate) -> ()) {

    let visionImage = VisionImage(buffer: sampleBuffer)

    visionImage.orientation = .right // FIXME hard-coded orientation

    TextRecognizer.textRecognizer().process(visionImage) { result, error in
        guard error == nil, let result = result else {
            print("Failed to get text recognition data")
            return
        }
        if !result.text.isEmpty {
            let result = ExpiryDateParser().parse(text: result.text)
            onSuccess(result)
        }
    }
}


func detectText(imageData: Data, onSuccess: @escaping (String) -> ()) {
    if let image = UIImage(data: imageData) {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = .right // FIXME hard-coded orientation

        TextRecognizer.textRecognizer().process(visionImage) { result, error in
            guard error == nil, let result = result else {
                print("Failed to get text recognition data")
                return
            }
            if !result.text.isEmpty {
                onSuccess(result.text)
            }
        }
    } else {
        print("Unable to create image from image data")
    }
}
