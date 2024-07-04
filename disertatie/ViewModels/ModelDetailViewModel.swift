//
//  ModelDetailViewModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 18.04.2024.
//

import Foundation
import RealityKit
@MainActor
final class ModelDetailViewModel:ObservableObject{
    @Published var entity: Entity?
    
    func fetchEntity(modelGiven: UsdzModel) async {
        let modelURL = URL(string: modelGiven.modelURL!)
        do {
            //downloaded the model
            let temporaryStoredModelLocationOnPhone = try await downloadAssetBasedOnURL(urlGiven: modelURL!, modelName: modelGiven.name ?? "nil")
            print("DEBUG: \(modelGiven.name ?? "default") usdz asset loaded... ")
            //loading the entity from temporary local file
            let entity = try? Entity.load(contentsOf: temporaryStoredModelLocationOnPhone!)
            self.entity = entity
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
