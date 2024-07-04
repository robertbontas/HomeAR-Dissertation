//
//  ModelDetailView.swift
//  disertatie
//
//  Created by Bontaș Robert on 18.04.2024.
//

import SwiftUI
import RealityKit
import ARKit
struct ModelDetailView: View {
    @StateObject var modelDetailViewModel = ModelDetailViewModel()
    let model: UsdzModel
    var body: some View {
        VStack{
            Spacer()
            if let thumbnailURLString = model.thumbnailURL, let thumbnailURL = URL(string: thumbnailURLString) {
                AsyncImage(url: thumbnailURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity / 2)
                            .clipped()
                    } else {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
            } else {
                ProgressView().progressViewStyle(.circular)
            }

            Divider()
            Spacer()
            VStack{
                Text("Name: \(model.name ?? "nil")")
                Text("Category: \(model.category ?? "nil") ")
                Text("Description: \(model.description ?? "nil")")
                Button(action: {
                    if let productURLString = model.productURL, let productURL = URL(string: productURLString) {
                        UIApplication.shared.open(productURL)
                    }
                }) {
                    Label("Buy from here", systemImage: "cart.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            Spacer()
        }
        .onAppear {
            Task {
                await modelDetailViewModel.fetchEntity(modelGiven: model)
            }
        }
    }
}

//struct for ArViewScene that loads my model
struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var mdvm: ModelDetailViewModel
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        if let entity = mdvm.entity {
            // Check if the anchor entity is already added to the scene
            if arView.scene.anchors.isEmpty {
                print("DEBUG no anchors entity added ")
                // Create anchor entity for the model
                let anchorEntity = AnchorEntity(world: [0, 0, -1])
                anchorEntity.position.y = 0 // Adjust height if needed
                anchorEntity.addChild(entity)
                // Add anchor entity to the scene
                entity.transform.rotation = simd_quatf(angle: .pi, axis: [0, 1, 0]) // Rotate around Y axis

                arView.scene.addAnchor(anchorEntity)
                
            }
            print("DEBUG anchor exists ")
            // Configure the environment with a white background
            arView.environment.background = .color(.gray)
            
        }
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update the view if needed
    }
}

