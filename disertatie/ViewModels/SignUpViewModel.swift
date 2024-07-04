//
//  SignUpViewModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 30.03.2024.
//

import Foundation
import Observation

@Observable
class SignUpViewModel{
    var email = ""
    var password = ""
    var confirmPassword = ""
    var username = ""
    var showError = false
    var errorMessage = ""
    func registerWithEmail(){
        Task
        {
            do {
                //validating fields
                try validateRegistration()
                //creating user in FirebaseAuthentication service [FRONTEND]
                let authDataResult = try await AuthService.sharedInstance.registerWithEmail(email: email, password: password,username:username)
                //formatting today date so i can store it for date_created
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM yyyy"
                let formattedDateOfToday = dateFormatter.string(from: Date())
                //creating a user model for my database in Firestore using the custom constructor
                let user = UserModelFirestoreDatabase(auth: authDataResult, dateGiven: formattedDateOfToday)
                // creating user in Firestore [BACKEND]
                try await UserService.sharedInstance.createNewUser(user: user)
            }            //catching errors and displaying functionalities
            catch let error as AuthError{
                errorMessage=error.localizedDescription
                showError = true
            }
            catch{
                errorMessage=error.localizedDescription
                showError = true
            }
        }
    }
    
    func validateRegistration() throws {
        if !email.isValidEmail(){
            throw AuthError.invalidEmail
        }else if password.count < 8 || confirmPassword.count < 8{
            throw AuthError.invalidPasswordLength
        }else if password != confirmPassword {
            throw AuthError.passwordNotTheSame
        }else if username.count < 3 || username.count > 24{
            throw AuthError.usernameLength
        }
    }
}
