//
//  RealTimeCameraViewModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 06.04.2024.
//

import Foundation
import RealityKit
import Combine
@MainActor
final class RealTimeCameraViewModel:ObservableObject{
    @Published private(set) var usdzsArray: [UsdzModel]? = nil// an array of USDZ's models (records)
    @Published private(set) var selectedModel: UsdzModel? // first pick from thumbnail button
    @Published private(set) var selectedModelEntity: Entity? // last assign as a entity
    @Published var isPlacementEnabled: Bool = false
    @Published private(set) var modelConfirmedForPlacement:UsdzModel? // after confirmation
    @Published var showDesignSavingOption = false
    @Published var showDesignNameError = false
    @Published var designName = ""
    
    // fetching models on view appear so thumbnails can be loaded
    func fetchModels() async throws{
        do{
            //making the query
            let querySnapshot = try await UsdzService.sharedInstance.getRecords()
            // create an array to store the fetched models
            var models: [UsdzModel] = []
            //for every result in query populate model array
            for document in querySnapshot.documents{
                let data = document.data()
                let usdzModel = UsdzModel(
                    usdzId: data["usdzId"] as? String ?? "",
                    name: data["name"] as? String,
                    category: data["category"] as? String,
                    description: data["description"] as? String,
                    modelURL: data["modelURL"] as? String,
                    thumbnailURL: data["thumbnailURL"] as? String,
                    productURL: data["productURL"] as? String
                )
                models.append(usdzModel)
            }
            self.usdzsArray = models
        }
        catch{
            print("DEBUG error in fetchModels: \(error.localizedDescription)")
        }
    }
    
    //SETTER FOR SELECTED MODEL:
    func updateSelectedModel(to model: UsdzModel?) {
        selectedModel = model
        print("DEBUG: selectedModel got assigned in ModelPickerView-> \(self.selectedModel?.name ?? "nil")")
    }
    
    //SETTER FOR Placement CONFIRMED SELECTED MODEL:
    func updateConfirmSelectedModel(to model: UsdzModel?) {
        modelConfirmedForPlacement = model
        print("DEBUG: modelConfirmedForPlacement got assigned in PlacementView -> \(self.modelConfirmedForPlacement?.name ?? "nil")")
    }
    
    func updateModelEntitySelected(to model: Entity?){
        selectedModelEntity = model
        print("DEBUG: entityModel got assigned -> \(self.selectedModelEntity?.name ?? "nil")")
    }
    
    
    
    func fetchModelEntityFromWeb() async {
        // making the URL
        guard let _ = self.modelConfirmedForPlacement, let url = URL(string: (self.modelConfirmedForPlacement?.modelURL)!) else {
            print("Invalid model or URL when fetching the 3D.usdz model from web")
            return
        }
        do {
            //downloaded the model
            let temporaryStoredModelLocationOnPhone = try await downloadAssetBasedOnURL(urlGiven: url, modelName: (self.modelConfirmedForPlacement?.name)!)
            print("DEBUG: \(self.modelConfirmedForPlacement?.name ?? "default") usdz asset loaded... ")
            //loading the entity from temporary local file
            let entity = try? Entity.load(contentsOf: temporaryStoredModelLocationOnPhone!)
            entity?.name = (self.modelConfirmedForPlacement?.usdzId)!
            self.updateModelEntitySelected(to: entity)
        } catch {
            print("Error fetching model entity: \(error)")
        }
    }
    
    
    func downloadAssetBasedOnURL(urlGiven : URL, modelName: String) async throws -> URL?{
        let fileManager = FileManager.default
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(modelName)
            .appendingPathExtension("usdz")
        
        // Check if file already exists at the destination URL
        if fileManager.fileExists(atPath: fileURL.path) {
            //print("Model already exists locally at: \(fileURL)")
            return fileURL
        }
        
        // File doesn't exist locally, proceed with downloading
        do {
            let (data, _) = try await URLSession.shared.data(from: urlGiven)
            
            // Save the downloaded data to the file
            try data.write(to: fileURL)
            //print("Model downloaded and stored locally at: \(fileURL)")
            
            return fileURL
        } catch {
            print("An error occurred when downloading asset from the web. Description: \(error.localizedDescription)")
            return nil
        }
    }
    
}

