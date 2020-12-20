//
//  Vision.swift
//  pantry
//
//  Created by Joris on 12.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import AVFoundation
import MLKit
import os


struct TextDetector {

    static let instance = TextDetector()

    private let logger = Logger(subsystem: App.name, category: "ExpiryDateFinder")

    private let textRecognizer = TextRecognizer.textRecognizer()

    private let expiryDateParser = ExpiryDateParser()

    private init() {}

    func detectExpiryDate(sampleBuffer: CMSampleBuffer, cameraPosition: AVCaptureDevice.Position) -> ParsedExpiryDate? {

        let image = VisionImage(buffer: sampleBuffer)
        image.orientation = .right // Only one orientation allowed in app

        if let result = try? textRecognizer.results(in: image) {

            logger.debug("Detected text: '\(result.text)'")
            if !result.text.isEmpty {

                return expiryDateParser.parse(text: result.text)
            }

        } else {
            print("Failed to get text recognition data")
        }

        return nil
    }

    func detectText(imageData: Data, onSuccess: @escaping (String) -> ()) {
        if let image = UIImage(data: imageData) {
            let visionImage = VisionImage(image: image)
            visionImage.orientation = .right // FIXME hard-coded orientation

            TextRecognizer.textRecognizer().process(visionImage) { result, error in
                guard error == nil, let result = result else {
                    logger.reportError("Failed to get text recognition data")
                    return
                }
                if !result.text.isEmpty {
                    onSuccess(result.text)
                }
            }
        } else {
            logger.reportError("Unable to create image from image data")
        }
    }

}





