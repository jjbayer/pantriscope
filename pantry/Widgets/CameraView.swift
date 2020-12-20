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
    
    func makeUIView(context: Context) -> CameraUIView {

        return CameraUIView(camera)
    }
    
    func updateUIView(_ uiView: CameraUIView, context: Context) {
        uiView.reconnect()
    }

    static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator) {
        uiView.disconnect()
    }
}
