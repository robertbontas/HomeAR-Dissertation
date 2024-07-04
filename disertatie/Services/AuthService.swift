//
//  AuthService.swift
//  disertatie
//
//  Created by Bontaș Robert on 30.03.2024.
//

import Foundation
import FirebaseAuth

@Observable // to listen to changes
final class AuthService {
    var currentUser:FirebaseAuth.User?
    private let auth = Auth.auth()
    
    //Singleton
    static let sharedInstance = AuthService()

    private init(){
        //setting current user stored on Auth state on initialization
        self.currentUser = auth.currentUser
    }
    func getCurrentUserUid()->String{
        return self.currentUser?.uid ?? ""
    }
    //without async because it is looking for user locally, it is not reaching firebase servers
    func getAuthenticatedUser() throws -> AuthDataResultModel{
        //getting the user logged in already, if no user is logged this is nil/
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    // Register function
    func registerWithEmail(email:String,password:String,username:String) async throws-> AuthDataResultModel {
        do{
            let resultAsTypeAuthDataModel = try await auth.createUser(withEmail: email, password: password)
            // Update the user's display name with the provided username
            let changeRequest = resultAsTypeAuthDataModel.user.createProfileChangeRequest()
            changeRequest.displayName = username
            try await changeRequest.commitChanges()
            // set the current user of Authentication State to user just created
            currentUser = resultAsTypeAuthDataModel.user
            print("DEBUG MODE - an user got registered: \(resultAsTypeAuthDataModel.user)")
            return AuthDataResultModel(user: resultAsTypeAuthDataModel.user)

        }
        catch{
                let error = error as NSError
                switch error.code {
                case AuthErrorCode.invalidEmail.rawValue:
                    throw AuthError.invalidEmail
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    throw AuthError.emailAlreadyInUse
                case AuthErrorCode.wrongPassword.rawValue:
                    throw AuthError.wrongPassword
                case AuthErrorCode.networkError.rawValue:
                    throw AuthError.networkError
                default:
                    throw AuthError.networkError
                }
            
        }
    }
    
    // Sign In Function
    func signInWithEmail(email:String, password:String) async throws
    {
        do{
            let result = try await auth.signIn(withEmail: email, password: password)
            currentUser = result.user
            print("DEBUG MODE - an user just logged in: \(result.user)")
        }
        catch{
            let error = error as NSError
            switch error.code {
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthError.invalidEmail
            case AuthErrorCode.wrongPassword.rawValue:
                throw AuthError.wrongPassword
            case AuthErrorCode.networkError.rawValue:
                throw AuthError.networkError
            default:
                throw AuthError.networkError
            }
        }
    }
    
    // Reset password Function
    func resetPassword(email:String) async throws{
        try await auth.sendPasswordReset(withEmail: email)
        print("DEBUG MODE - an user try to change it's password: \(email )")
    }
    
    // Sign Out Function
    func signOut() throws
    {
        print("DEBUG MODE - an user got logged out: \(currentUser?.email ?? "default@yahoo.com")")
        try auth.signOut()
        currentUser = nil
    }
    
    func deleteAccount() async throws {
        // deleting user from firebase firestore(database)
        try await UserService.sharedInstance.deleteUser(userId: currentUser!.uid)
        try await currentUser?.delete() //deleting user from fireabseauth
    }
    
    func resetEmail(newEmail:String) async throws{
        //sending email reset link to user
        try await currentUser?.sendEmailVerification(beforeUpdatingEmail: newEmail)
        // Update email in Firestore
        try await UserService.sharedInstance.updateUserEmail(userId: currentUser?.uid ?? "", email: newEmail)
    
    }
}
