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
    
    typealias UIViewType = CameraUIView
    
    let camera = Camera()
    let uiView = CameraUIView()


    init() {
        print("CameraView.init")
        camera.setUp(view: self.uiView)
    }
    
    func makeUIView(context: Context) -> CameraUIView {
        print("CameraView.makeUIView")
        
        return uiView
    }
    
    func updateUIView(_ uiView: CameraUIView, context: Context) {
        print("CameraView.updateUIView")
        print(uiView.videoPreviewLayer.isPreviewing)
    }

    func takeSnapshot(delegate: AVCapturePhotoCaptureDelegate) {
        print("CameraView.takeSnapshot")
        camera.output.capturePhoto(
            with: AVCapturePhotoSettings(),
            delegate: delegate
        )
    }

    static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator) {
        print("CameraView.dismantleUIView")
        uiView.captureSession.stopRunning()
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
