//
//  UserService.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.03.2024.
//

import Foundation
import FirebaseFirestore

@Observable // to listen to changes
final class UserService{
    //Singleton
    static let sharedInstance = UserService()
    //reference to the users collection
    private let userCollection = Firestore.firestore().collection("users")
    //reference to a user document(record) in database
    private func userDocument(userId:String) -> DocumentReference {
         return userCollection.document(userId)
    }
    // sser creation in database
    func createNewUser(user: UserModelFirestoreDatabase) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
        //setting the user profile photo as default
        try await userDocument(userId: user.userId).updateData(["profile_image_path":"https://firebasestorage.googleapis.com/v0/b/my-dissertation-e0e51.appspot.com/o/users_profile_pictures%2Fdefault%2Fdefault.jpg?alt=media&token=b7af6a3a-4e8f-4891-b48c-b5012b0f0bb8"])
        print("DEBUG MODE - an user got created in database: \(user.email ?? "default_email")")
        

    }
    // getting a user from database
    func getUser(userId: String) async throws -> UserModelFirestoreDatabase {
        try await userDocument(userId: userId).getDocument(as: UserModelFirestoreDatabase.self)
    }
    // Deleting a user from the database
    func deleteUser(userId: String) async throws {
        try await userDocument(userId: userId).delete()
        print("DEBUG MODE - User with ID \(userId) has been deleted from the database.")
    }
    
    func updateUserEmail(userId: String, email: String) async throws {
        // Update the email field in the user document
        try await userDocument(userId: userId).updateData(["email": email])
        print("DEBUG MODE - User with ID \(userId) has changed it's email in database to: \(email).")
    }
    
    func updateUsername(userId: String, newUsername: String) async throws {
        try await userDocument(userId: userId).updateData(["username": newUsername])
    }
    
    func updateUserProfilePicturePath ( userId: String, path:String )async throws{
        try await userDocument(userId: userId).updateData(["profile_image_path":path])
    }
}
