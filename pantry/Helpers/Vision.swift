//
//  Vision.swift
//  pantry
//
//  Created by Joris on 12.10.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import AVFoundation
import MLKit


func detectExpiryDate(sampleBuffer: CMSampleBuffer, cameraPosition: AVCaptureDevice.Position) -> ParsedExpiryDate? {

    let image = VisionImage(buffer: sampleBuffer)
    image.orientation = imageOrientation(
      deviceOrientation: UIDevice.current.orientation,
      cameraPosition: cameraPosition)

    if let result = try? TextRecognizer.textRecognizer().results(in: image) {

        print("Detected text: '\(result.text)'")
        if !result.text.isEmpty {

            return ExpiryDateParser().parse(text: result.text)
        }

    } else {
        print("Failed to get text recognition data")
    }

    return nil
}


/// Copied from https://developers.google.com/ml-kit/vision/text-recognition/ios
func imageOrientation(
  deviceOrientation: UIDeviceOrientation,
  cameraPosition: AVCaptureDevice.Position
) -> UIImage.Orientation {
  switch deviceOrientation {
  case .portrait:
    return cameraPosition == .front ? .leftMirrored : .right
  case .landscapeLeft:
    return cameraPosition == .front ? .downMirrored : .up
  case .portraitUpsideDown:
    return cameraPosition == .front ? .rightMirrored : .left
  case .landscapeRight:
    return cameraPosition == .front ? .upMirrored : .down
  case .faceDown, .faceUp, .unknown:
    return .up
  @unknown default:
    print("Unknown UIImage orientation '\(deviceOrientation)'")
    return .right
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
