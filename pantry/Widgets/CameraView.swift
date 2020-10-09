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
    
    init() {
        print("CameraView.init")
    }
    
    func makeUIView(context: Context) -> CameraUIView {
        print("CameraView.makeUIView")

        return CameraUIView()
    }
    
    func updateUIView(_ uiView: CameraUIView, context: Context) {
        uiView.reconnect()
        let s = Camera.instance.captureSession
        print("CameraView.updateUIView: isRunning \(s.isRunning), isInterrupted \(s.isInterrupted), previewing: \(uiView.videoPreviewLayer.isPreviewing)")
    }

    static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator) {
        print("CameraView.dismantleUIView")
        uiView.disconnect()
//        Camera.instance.captureSession.stopRunning()
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
