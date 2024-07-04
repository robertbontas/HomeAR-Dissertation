//
//  ArSceneInstance.swift
//  disertatie
//
//  Created by Bontaș Robert on 12.04.2024.
//

import Foundation
import RealityKit
import ARKit

@Observable
class ArSceneInstance{     //this will hold the state of the Augumented Reality Scene
    //Singleton
    static let sharedInstance = ArSceneInstance()
    private var arSceneInstance : ARView?
    
    func initializeARView() {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        
        arView.session.run(configuration)
        
        self.arSceneInstance = arView
    }
    //setter
    func setArSceneInstance(_ arView: ARView) {
        arSceneInstance = arView
    }
    
    //func to get the ar scene in a specific state
    func getArSceneState() -> ARView? {
        return arSceneInstance
    }
    // saving design to cloud functionality
    func saveDesignCloud(designName:String) async throws{
        do{
            //checking designName
            if designName.count <= 0 {
                throw AuthError.usernameLength
            }else{
            //getting name of the design
            let nameOfDesign = designName
            //getting ids of models placed in the scene
            let listOfEntitiesIds = self.getModelsAttachedToScene()
            //take snapshot
                await ArSceneInstance.sharedInstance.captureSnapshot { image in
                    Task{
                        do {
                            if let completionImage = image {
                                let designSnapshot = completionImage
                                let userId = AuthService.sharedInstance.currentUser!.uid
                                // Upload the image to the cloud
                                let (path, _) = try await DesignService.sharedInstance.saveImage(image: designSnapshot, userId: userId)
                                //get its url
                                let designUrl = try await StorageService.sharedInstance.getUrlForImage(path: path)
                                print("DEBUG: url \(designUrl)")
                                //constructing the date created
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd MMMM yyyy"
                                let formattedDateOfToday = dateFormatter.string(from: Date())
                                //construct the design
                                let design = DesignModel(userId: userId, designName: nameOfDesign, dateCreated: formattedDateOfToday, designUrl: designUrl, modelsId: listOfEntitiesIds)
                                try await DesignService.sharedInstance.saveDesignToUser(design: design, uid: userId)
                            } else {
                                // Handle error if capturing snapshot fails
                                print("DEBUG: Unable to save snapshot")
                            }
                        } catch {
                            // Handle error if saving image to cloud fails
                            print("DEBUG: Error saving image to cloud - \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        catch{
            throw AuthError.usernameLength
        }
    }
    
    //func to freeze the scene
    func freezeSceneInstance(){
        self.arSceneInstance?.session.pause()
    }
    //func to resume scene
    func resumeSceneInstance(){
        self.arSceneInstance?.session.run(ARWorldTrackingConfiguration())
    }
    func restartSceneInstance(){
        self.arSceneInstance?.scene.anchors.removeAll()
        guard let configuration = self.arSceneInstance?.session.configuration else{
            fatalError("Unable to get previous scene configuration")
        }
        self.arSceneInstance?.session.run(configuration,options:[.removeExistingAnchors,.resetTracking])
    }
    
    //func to take snapshot of the scene{
    func captureSnapshot(completion: @escaping (UIImage?) -> Void) async{
        await self.arSceneInstance?.snapshot(saveToHDR: false){
            image in
            if let imageData = image?.pngData(), let capturedImage = UIImage(data: imageData) {
                completion(capturedImage)
            }else {
                completion(nil)
            }
        }
    }
    
    // save the image to the phone's photo library
    // Save the image to the phone's photo library
    func saveImageToPhotoLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    //func to get the models in a certain state
    func getModelsAttachedToScene() -> [String]{
        var entitiesIds: [String] = []
        // Getting models from scene function got called
        // why anchor -> parent -> entity instead of anchor -> entity?
        // i have an extra layer called parent because this serve for me as a mesh with boundaries for the object
        // because in RealityKit you cannot apply gestures directly to a imported models because it doesn't have regular form such as a box
        if let anchors = self.arSceneInstance?.scene.anchors{
            for anchor in anchors {
                for parent in anchor.children {
                    for entity in parent.children{
                        print("DEBUG: Model Entity found in anchors: \(entity.name)")
                        //appending entity's ID to array of IDs
                        let currentEntityId = entity.name
                        if !entitiesIds.contains(currentEntityId){
                            entitiesIds.append(currentEntityId)
                        }
                        
                    }
                }
            }
        }
        return entitiesIds
    }
}
