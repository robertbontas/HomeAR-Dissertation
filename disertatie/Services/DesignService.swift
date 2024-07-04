//
//  DesignService.swift
//  disertatie
//
//  Created by Bontaș Robert on 17.04.2024.
//

import Foundation
import FirebaseStorage
import UIKit
import FirebaseFirestore
@Observable
final class DesignService{
    static let sharedInstance = DesignService()
    private let storage = Storage.storage().reference()
    private var designReference: StorageReference{
        storage.child("designs")
    }
    private func designByUserReference(userId : String?) -> StorageReference {
        storage.child("designs").child(userId!)
    }
    private let userCollection = Firestore.firestore().collection("users")
    
    func fetchUserDesigns(userId: String, completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        userCollection.document(userId).collection("designs").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching designs: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                completion([], nil)
                return
            }
            // completion as list of queryDocumentSnapshot and i will convert it in viewModel
            completion(documents, nil)
        }
    }
    
    func deleteDesignById(designId: String, uid:String) {
        let userReference = userCollection.document(uid)
        userReference.collection("designs").document(designId).delete{ error in
            if let error = error {
                print("Error deleting design: \(error.localizedDescription)")
            } else {
                print("DEBUG: Design deleted successfully")
            }
        }
    }
    
    //helper for saving it to a reference
    func saveImageHelper(data:Data, userId: String) async throws -> (path:String, name:String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await designByUserReference(userId: userId).child(path).putDataAsync(data, metadata: meta )
        
        guard let pathOfMetaData = returnedMetaData.path, let nameOfMetaData = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        return (pathOfMetaData, nameOfMetaData)
    }
    func saveImage(image:UIImage, userId: String) async throws -> (path:String, name:String){
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        return try await saveImageHelper(data: data, userId: userId)
    }
    func saveDesignToUser(design:DesignModel,uid:String) async throws{
        //the user reference
        let userReference = userCollection.document(uid)
        let designData: [String: Any]
        do {
            designData = try Firestore.Encoder().encode(design)
        } catch {
            print("DEBUG Error encoding design: \(error)")
            return
        }
        userReference.collection("designs").addDocument(data: designData){ error in
            if let error = error {
                print("DEBUG Error adding document: \(error)")
            } else {
                print("DEBUG Design added successfully!")
            }
        }
    }
}
