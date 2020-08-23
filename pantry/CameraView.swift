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
    
    func makeUIView(context: Context) -> CameraUIView {
        print("make camera ui view")
        
        let uiView = CameraUIView()

        camera.setUp(captureSession: self.captureSession, view: uiView)
        
        return uiView
    }
    
    func updateUIView(_ uiView: CameraUIView, context: Context) {
        print("update camera ui view")
    }
}
