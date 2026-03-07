//
//  ARScannerViewModel.swift
//  ARSpatialScanner
//
//  Created by Sumesh on 07/03/26.
//

import Foundation
import ARKit
import Combine

class ARScannerViewModel: ObservableObject {
    
    let sessionManager = ARSessionManager()
    
    @Published var isScanning: Bool = false
    @Published var detectedObject: String? = nil
    
    init() {
        sessionManager.viewModel = self
    }
    
    func startScanning() {
        isScanning = true
        detectedObject = nil
    }
    
    func stopScanning() {
        isScanning = false
    }
    
    func objectDetected(name: String) {
        DispatchQueue.main.async {
            self.detectedObject = name
            self.isScanning = false
        }
    }
    
    func dismissResult() {
        detectedObject = nil
    }
    
}
