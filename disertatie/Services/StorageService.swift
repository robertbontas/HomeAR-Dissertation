//
//  StorageService.swift
//  disertatie
//
//  Created by Bontaș Robert on 01.04.2024.
//
import FirebaseStorage
import Foundation
import UIKit

@Observable // to listen to changes
final class StorageService {
    //Singleton
    static let sharedInstance = StorageService()
    //locations and references of my storage
    private let storage = Storage.storage().reference()
    private var profilePicturesReferences : StorageReference{
        storage.child("profile_pictures_images")
    }
    private func userProfilePictureReference(userId : String) -> StorageReference {
        storage.child("users_profile_pictures").child(userId)
    }
    private var modelsReference: StorageReference{
        storage.child("3d_models")
    }
    func getModelsReference()->StorageReference{
        return modelsReference
    }
    //save image function called by viewModel
    //there is called a function that compress the image from utils
    func saveImage(image:UIImage, userId: String) async throws -> (path:String, name:String){
        guard let data = resizeImage(image: image, targetSize: CGSize(width: 400, height: 400))?.jpegData(compressionQuality: 1) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        return try await saveImageHelper(data: data, userId: userId)
    }
    //helper for saving it to a reference
    func saveImageHelper(data:Data, userId: String) async throws -> (path:String, name:String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userProfilePictureReference(userId: userId).child(path).putDataAsync(data, metadata: meta )
        
        guard let pathOfMetaData = returnedMetaData.path, let nameOfMetaData = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }

        return (pathOfMetaData, nameOfMetaData)
    }
    //getting url of image by a path given
    func getUrlForImage(path:String) async throws -> URL {
        try await Storage.storage().reference(withPath: path).downloadURL()
    }
}
