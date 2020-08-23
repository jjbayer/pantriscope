//
//  CameraController.swift
//  pantry
//
//  Created by Joris on 23.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import AVFoundation
 
class CameraController {
    var captureSession: AVCaptureSession?
 
    var camera: AVCaptureDevice?
    var cameraInput: AVCaptureDeviceInput?
 
    var photoOutput: AVCapturePhotoOutput?
 
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
 
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            
            for camera in session.devices {
                if camera.position == .back {
                    self.camera = camera
 
                    try camera.lockForConfiguration()
                    camera.focusMode = .autoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
 
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
 
            if let camera = self.camera {
                self.cameraInput = try AVCaptureDeviceInput(device: camera)
 
                if captureSession.canAddInput(self.cameraInput!) { captureSession.addInput(self.cameraInput!) }
            }
 
            else { throw CameraControllerError.noCamerasAvailable }
        }
 
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
 
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
 
            if captureSession.canAddOutput(self.photoOutput!) {
                captureSession.addOutput(self.photoOutput!)
            }
            captureSession.startRunning()
        }
 
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }
 
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
 
                return
            }
 
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }

    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
}
