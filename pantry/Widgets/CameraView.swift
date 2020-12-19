//
//  CameraView.swift
//  pantry
//
//  Created by Joris on 23.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import SwiftUI
import AVFoundation

import AVFoundation


struct CameraView: UIViewRepresentable {

    @EnvironmentObject var camera: Camera

    typealias UIViewType = CameraUIView
    
    init() {
        print("CameraView.init")
    }
    
    func makeUIView(context: Context) -> CameraUIView {
        print("CameraView.makeUIView")

        return CameraUIView(camera)
    }
    
    func updateUIView(_ uiView: CameraUIView, context: Context) {
        uiView.reconnect()
        let s = camera.captureSession
        print("CameraView.updateUIView: isRunning \(s.isRunning), isInterrupted \(s.isInterrupted), previewing: \(uiView.videoPreviewLayer.isPreviewing)")
    }

    static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator) {
        print("CameraView.dismantleUIView")
        uiView.disconnect()
    }
}
