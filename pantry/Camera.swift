//
//  Camera.swift
//  pantry
//
//  Created by Joris on 23.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import AVFoundation

struct Camera {
    
    func setUp(captureSession: AVCaptureSession, view: CameraUIView) {
        print("init camera")
    
        let device = getDevice()
        
        // https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/setting_up_a_capture_session
        let videoDeviceInput = try? AVCaptureDeviceInput(device: device)


        if !captureSession.canAddInput(videoDeviceInput!) { // FIXME: unwrapping
            fatalError("Failed to add video input")
        }
        captureSession.addInput(videoDeviceInput!) // FIXME: unwrapping

        captureSession.beginConfiguration()

        let photoOutput = AVCapturePhotoOutput()
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported


        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)

        view.videoPreviewLayer.session = captureSession

        captureSession.commitConfiguration()
        captureSession.startRunning()

        print("Capture session is running")

    }
    
    func getDevice() -> AVCaptureDevice {
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
