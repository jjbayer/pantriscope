//
//  CameraView.swift
//  pantry
//
//  Created by Joris on 23.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    
    typealias UIViewType = CameraUIView
    
    let captureSession = AVCaptureSession()
    let camera = Camera()
    let uiView = CameraUIView()


    init() {
        print("Init camera view")
        camera.setUp(captureSession: self.captureSession, view: self.uiView)

    }
    
    func makeUIView(context: Context) -> CameraUIView {
        print("make camera ui view")
        
        return uiView
    }
    
    func updateUIView(_ uiView: CameraUIView, context: Context) {
        print("update camera ui view")
        print(uiView.videoPreviewLayer.isPreviewing)
    }
}
