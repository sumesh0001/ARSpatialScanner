//
//  ObjectResultView.swift
//  ARSpatialScanner
//
//  Created by Sumesh on 07/03/26.
//


import SwiftUI

struct ObjectResultView: View {
    
    let objectName: String
    var onDismiss: () -> Void
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            HStack {
                
                Spacer()
                
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            
            Text("Detected Object")
                .font(.headline)
            
            Text(objectName)
                .font(.title)
                .bold()
            
            Text("This looks like a \(objectName).")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
        }
        .padding()
        .frame(width: 260)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

#Preview {
    ObjectResultView(objectName: "Sample object", onDismiss: {})
}

