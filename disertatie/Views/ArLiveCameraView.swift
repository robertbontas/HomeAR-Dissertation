//
//  ArLiveCameraView.swift
//  disertatie
//
//  Created by Bontaș Robert on 09.04.2024.
//

import SwiftUI
import RealityKit
import ARKit

struct ArLiveCameraView: UIViewRepresentable {
    
    @EnvironmentObject var realTimeCameraViewModel: RealTimeCameraViewModel
    
    //MAKING THE AR VIEW
    func makeUIView(context: Context) -> ARView{
        //initiliazing ar scene through service i created:
        ArSceneInstance.sharedInstance.initializeARView()
        // retrieve arview instance from service
        guard let arView = ArSceneInstance.sharedInstance.getArSceneState() else {
            fatalError("DEBUG: Failed to initilize ArScene")
        }
        return arView
    }
    
    //UPDATING THE AR VIEW
    func updateUIView(_ uiView: ARView, context: Context) {
        print("DEBUG: update ar view happened")
            if let entityOnScene = realTimeCameraViewModel.selectedModelEntity {
                //setting the scale of my entity as a SIMD3 type vector
                entityOnScene.setScale(SIMD3(repeating: 0.01), relativeTo: nil)
                // parentEntity
                let parentEntity = ModelEntity()
                parentEntity.addChild(entityOnScene)
                parentEntity.name = realTimeCameraViewModel.selectedModelEntity!.name
                // anchor
                let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: .zero))
                anchor.addChild(parentEntity)
                // adding the anchor to my scene
                uiView.scene.addAnchor(anchor)
                
                // Play availableAnimations on repeat
                entityOnScene.availableAnimations.forEach{ entityOnScene.playAnimation($0.repeat()) }
                
                // Add a collision component to the parentEntity
                let entityBounds = entityOnScene.visualBounds(relativeTo: parentEntity)
                parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
                
                // Install gestures for the parentEntity
                uiView.installGestures(for: parentEntity)
                uiView.enableObjectRemoval()
                //after placing happened
                //because of error: Modifying state during view update, this will cause undefined behavior.
                DispatchQueue.main.async{
                    print("DEBUG: in update ar view models to be set to nil")
                    //deleting entity after it was placed confirmation also
                    realTimeCameraViewModel.updateModelEntitySelected(to: nil)
                    realTimeCameraViewModel.updateConfirmSelectedModel(to: nil)
                }
            } else {
                print("DEBUG: no model entity is selected")
            }

    }

}


