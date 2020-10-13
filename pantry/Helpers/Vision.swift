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


func detectExpiryDate(sampleBuffer: CMSampleBuffer) {
    let visionImage = VisionImage(buffer: sampleBuffer)

    visionImage.orientation = .right // FIXME hard-coded orientation

    TextRecognizer.textRecognizer().process(visionImage) { result, error in
        guard error == nil, let result = result else {
            print("Failed to get text recognition data")
            return
        }
        if !result.text.isEmpty {
            print("Detected text: '\(result.text)'")
            let parsed = ExpiryDateParser().parse(text: result.text)
            if parsed.confidence > 0.0 {
                print("Parsed date \(parsed.date) with confidence \(parsed.confidence).")
            }
        }
    }

}
