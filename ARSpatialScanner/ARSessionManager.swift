//
//  ARSessionManager.swift
//  ARSpatialScanner
//
//  Created by Sumesh on 07/03/26.
//

import ARKit
import RealityKit
import SwiftUI
import Vision
import CoreML


class ARSessionManager: NSObject, ARSessionDelegate {
    
    
    weak var arView: ARView?
    weak var viewModel: ARScannerViewModel?
    
    private var frameCounter = 0
    
    private var visionModel: VNCoreMLModel?
    
    // 👇 Background queue for ML detection
    private let visionQueue = DispatchQueue(label: "com.ar.objectDetection")
    
    override init() {
        super.init()
        
        do {
            let model = try MobileNetV2(configuration: MLModelConfiguration())
            visionModel = try VNCoreMLModel(for: model.model)
        } catch {
            print("Failed to load ML model")
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        guard viewModel?.isScanning == true else { return }
        
        frameCounter += 1
        if frameCounter % 30 != 0 { return }
        
        guard let points = frame.rawFeaturePoints?.points else { return }
        
        visionQueue.async { [weak self] in
            self?.detectObject(frame: frame)   // 👈 HERE
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.updatePointCloud(points)
        }
        
        // Demo detection
        //        let detectedName = "Bottle"
        //        viewModel?.objectDetected(name: detectedName)
    }
    
    func updatePointCloud(_ points: [SIMD3<Float>]) {
        
        guard let arView = arView else { return }
        
        let anchor = AnchorEntity(world: .zero)
        
        for point in points.prefix(200) {
            
            let mesh = MeshResource.generateSphere(radius: 0.003)
            let material = SimpleMaterial(color: .cyan, isMetallic: false)
            
            let entity = ModelEntity(mesh: mesh, materials: [material])
            entity.position = point
            
            anchor.addChild(entity)
        }
        
        arView.scene.anchors.removeAll()
        arView.scene.anchors.append(anchor)
    }
    
    func detectObject(frame: ARFrame) {
        
        guard let visionModel = visionModel else { return }
        
        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else { return }
            
            let objectName = topResult.identifier
            let confidence = topResult.confidence
            
            if confidence > 0.7 {
                DispatchQueue.main.async {
                    self?.viewModel?.objectDetected(name: objectName)
                }
            }
        }
        
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(
            cvPixelBuffer: frame.capturedImage,
            orientation: .up,
            options: [:]
        )
        
        try? handler.perform([request])
    }
}
