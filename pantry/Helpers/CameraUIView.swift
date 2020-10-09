//
//  CameraUIView.swift
//  pantry
//
//  Created by Joris on 23.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import AVFoundation
import UIKit

/// see https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/setting_up_a_capture_session
class CameraUIView: UIView {

    var captureSession = AVCaptureSession()
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
