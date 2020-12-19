//
//  Camera.swift
//  pantry
//
//  Created by Joris on 23.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//
import AVFoundation


class CaptureHandler: NSObject, AVCapturePhotoCaptureDelegate {

    var successFn: (Data?) -> ()

    init(onSuccess: @escaping (Data?) -> ()) {
        successFn = onSuccess
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        self.successFn(photo.fileDataRepresentation())
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
    let videoHandler = VideoHandler()
    var captureHandler: CaptureHandler? = nil

    let device = getDevice()

    var isWorking = true
    
    private init() {

        guard let device = self.device else {
            isWorking = false
            return
        }

        print("Camera.setUp")
    
        // https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/setting_up_a_capture_session

        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device) else {
            print("Failed to create video device input")
            isWorking = false
            return
        }

        if !captureSession.canAddInput(videoDeviceInput) {
            print("Failed to add video input")
            isWorking = false
            return
        }
        captureSession.addInput(videoDeviceInput)

        captureSession.beginConfiguration()

        output.isHighResolutionCaptureEnabled = true
        output.isLivePhotoCaptureEnabled = false


        guard captureSession.canAddOutput(output) else { return }
        captureSession.sessionPreset = .medium
        captureSession.addOutput(output)

        guard captureSession.canAddOutput(videoOutput) else {
            print("Cannot add video output")
            isWorking = false
            return
        }

        // begin settings from MLKit's vision example
        videoOutput.videoSettings = [
          (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
        ]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        let outputQueue = DispatchQueue(label: "video")
        // end
        videoOutput.setSampleBufferDelegate(videoHandler, queue: outputQueue)
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

    mutating func takeSnapshot(successFn: @escaping (Data?) -> ()) {
        let handler = CaptureHandler(onSuccess: successFn)
        captureHandler = handler // assign to member variable bc of lifetime issues

        guard isWorking else {
            print("Cannot use camera")
            return
        }

        output.capturePhoto(
            with: AVCapturePhotoSettings(),
            delegate: handler
        )
    }

    func onFrame(handler: @escaping (CMSampleBuffer) -> ()) {
        videoHandler.callback = handler
    }

    func clearFrameHandler() {
        videoHandler.callback = nil
    }
    
    static private func getDevice() -> AVCaptureDevice? {
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

            print("Could not find camera")

            return nil
        }
    }
    
}
