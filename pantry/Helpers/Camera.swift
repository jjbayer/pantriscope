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

class VideoHandler: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    var callback: ((CMSampleBuffer) -> ())? = nil

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let fun = callback {
            fun(sampleBuffer)
        }
    }
}


struct Camera {

    static var instance = Camera()

    let captureSession = AVCaptureSession()
    let output = AVCapturePhotoOutput()
    let videoOutput = AVCaptureVideoDataOutput()
    let captureHandler = CaptureHandler()
    let videoHandler = VideoHandler()
    
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

        guard captureSession.canAddOutput(videoOutput) else {
            print("Cannot add video output")
            return
        }

        videoOutput.setSampleBufferDelegate(videoHandler, queue: DispatchQueue.main)
        captureSession.addOutput(videoOutput)


        captureSession.commitConfiguration()
    }

    func connectPreview(previewLayer: AVCaptureVideoPreviewLayer) {
        captureSession.beginConfiguration()
        previewLayer.session = captureSession
        captureSession.commitConfiguration()
    }

    func stop() {
        DispatchQueue.main.async {
            captureSession.stopRunning()
        }
    }

    func start() {
        DispatchQueue.main.async {
            captureSession.startRunning()
        }
    }

    func takeSnapshot() {
        output.capturePhoto(
            with: AVCapturePhotoSettings(),
            delegate: captureHandler
        )
    }

    func onFrame(handler: @escaping (CMSampleBuffer) -> ()) {
        videoHandler.callback = handler
    }

    func clearFrameHandler() {
        videoHandler.callback = nil
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
