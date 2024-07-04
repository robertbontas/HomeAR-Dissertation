//
//  ArGesturesExt.swift
//  disertatie
//
//  Created by Bontaș Robert on 09.04.2024.
//
import RealityKit
import ARKit
//extension for arView to enable on hold gesture(for deleting)
extension ARView{
    func enableObjectRemoval(){
        // creating a recognizer for that
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target:self,action: #selector(handleLongPress(recognizer: )))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
        if recognizer.state == .began {
                    // Get the location of the long press
                    let location = recognizer.location(in: self)
                    if let entity = self.entity(at: location) {

                        // Trigger haptic feedback
                        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                        feedbackGenerator.impactOccurred()

                        // Remove the entity after a delay (for visual feedback)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if let anchorEntity = entity.anchor {
                                anchorEntity.removeFromParent()
                            }
                        }
                    }
                }
            }
    
}
