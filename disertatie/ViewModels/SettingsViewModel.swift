//
//  SettingsViewModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.03.2024.
//

import Foundation
import Observation
import FirebaseAuth

@Observable
class SettingsViewModel{
    private var _userEmail = ""
    var resetEmail = ""
    var showResetPassword = false
    var showDeleteConfirmation = false
    var showResetEmail = false
    var showError = false
    var errorMessage = ""
    
    var userEmail: String { // Computed property to expose userEmail
        return _userEmail
    }
    
    func fetchUserEmail() {
            if let email = AuthService.sharedInstance.currentUser?.email {
                self._userEmail = email
            } else {
                print("User email is nil")
            }
    }
    
    func signUserOut(){
        Task{
            do{
                try AuthService.sharedInstance.signOut()
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func resetUserPassword() async{
            do{
                try await AuthService.sharedInstance.resetPassword(email: userEmail)
            }
            catch{
                print(error.localizedDescription)
            }
    }
    
    func deleteAccount() async throws {
        do{
            // deleting it from authservice but there is also deleted from firestore, why? beccause in AuthService i have access easier to the uid then storing it in this view
            try await AuthService.sharedInstance.deleteAccount()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func resetUserEmail() async throws{
        do{
            //validate new email
            try validateEmailByEmailParam()
            //change it in frontend and also in backend
            try await AuthService.sharedInstance.resetEmail(newEmail: resetEmail)
            //sign user out
            try AuthService.sharedInstance.signOut()
        }
        catch let error as AuthError{
            errorMessage=error.localizedDescription
            showError = true
        }
        catch{
            errorMessage=error.localizedDescription
            showError = true
        }
    }
    
    
    func validateEmailByEmailParam() throws {
        if !resetEmail.isValidEmail(){
            throw AuthError.invalidEmail
        }
    }
}
