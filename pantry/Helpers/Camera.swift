//
//  Camera.swift
//  pantry
//
//  Created by Joris on 23.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import AVFoundation


class CaptureHandler: NSObject, AVCapturePhotoCaptureDelegate {

    var data: Data?

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        self.data = photo.fileDataRepresentation()
    }

}


struct Camera {

    static var instance = Camera()

    let captureSession = AVCaptureSession()
    let output = AVCapturePhotoOutput()
    let captureHandler = CaptureHandler()
    
    private init() {


        print("Camera.setUp")
    
        let device = getDevice()

        // https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/setting_up_a_capture_session
        let videoDeviceInput = try? AVCaptureDeviceInput(device: device)

        if !captureSession.canAddInput(videoDeviceInput!) { // FIXME: unwrapping
            fatalError("Failed to add video input")
        }
        captureSession.addInput(videoDeviceInput!) // FIXME: unwrapping

        captureSession.beginConfiguration()

        output.isHighResolutionCaptureEnabled = true
        output.isLivePhotoCaptureEnabled = output.isLivePhotoCaptureSupported


        guard captureSession.canAddOutput(output) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(output)

        captureSession.commitConfiguration()
        print("startRunning...")
        captureSession.startRunning()

        print("Capture session is running")

    }

    func connectPreview(previewLayer: AVCaptureVideoPreviewLayer) {
        captureSession.beginConfiguration()
        previewLayer.session = captureSession
        captureSession.commitConfiguration()
    }

    func takeSnapshot() {
        output.capturePhoto(
            with: AVCapturePhotoSettings(),
            delegate: captureHandler
        )
    }
    
    private func getDevice() -> AVCaptureDevice {
        // https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/choosing_a_capture_device
        if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                for: .video, position: .back) {
            print("Choosing dual camera")
            
            return device
            
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video, position: .back) {
           
            print("Choosing wide angle camera")
            
            return device
            
        } else {
            fatalError("Missing expected back camera device")
        }
    }
    
}
