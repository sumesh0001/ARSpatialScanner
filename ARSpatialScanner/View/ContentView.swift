//
//  ContentView.swift
//  ARSpatialScanner
//
//  Created by Sumesh on 07/03/26.
//


import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ARScannerViewModel()
    
    var body: some View {
        
        ZStack {
            
            ARViewContainer(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Button("Start Scan") {
                        viewModel.startScanning()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Stop Scan") {
                        viewModel.stopScanning()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            
            if let object = viewModel.detectedObject {
                
                ObjectResultView(
                    objectName: object,
                    onDismiss: {
                        viewModel.dismissResult()
                    }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
