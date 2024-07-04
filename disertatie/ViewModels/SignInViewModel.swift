//
//  SignInViewModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 30.03.2024.
//

import Foundation
import Observation

@Observable
class SignInViewModel {
    var email = ""
    var password = ""
    var forgotPasswordEmail = ""
    var showRegistration = false
    var showForgotPassword = false
    var showError = false
    var errorMessage = ""
    func signInWithEmail(){
        Task
        {
            do {
                try validateLogin()
                try await AuthService.sharedInstance.signInWithEmail(email: email, password: password)
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
    }
    func resetPassword() {
        Task{
            do {
                try validateEmail()
                try await AuthService.sharedInstance.resetPassword(email: forgotPasswordEmail)
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
    }
    func validateLogin() throws {
        if !email.isValidEmail(){
            throw AuthError.invalidEmail
        }else if password.count < 8{
            throw AuthError.invalidPasswordLength
        }
    }
    func validateEmail() throws {
        if !forgotPasswordEmail.isValidEmail(){
            throw AuthError.invalidEmail
        }
    }
}

