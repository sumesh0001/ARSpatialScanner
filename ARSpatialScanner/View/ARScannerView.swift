//
//  ARScannerView.swift
//  ARSpatialScanner
//
//  Created by Sumesh on 07/03/26.
//

import SwiftUI
import RealityKit
import ARKit


struct ARViewContainer: UIViewRepresentable {

    @ObservedObject var viewModel: ARScannerViewModel

    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]

        arView.session.run(config)

        viewModel.sessionManager.arView = arView
        arView.session.delegate = viewModel.sessionManager

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) { }
}
