//
//  AuthError.swift
//  disertatie
//
//  Created by Bontaș Robert on 30.03.2024.
//

import Foundation
//ERROR HANDLING
enum AuthError:Error {
    case invalidEmail
    case invalidPasswordLength
    case passwordNotTheSame
    case emailAlreadyInUse
    case wrongPassword
    case networkError
    case usernameLength
    
    var localizedDescription: String {
        switch self
        {
        case .invalidEmail:
            "Please enter an valid mail!"
        case .invalidPasswordLength:
            "Invalid password length. Password must have at least 8 characters!"
        case .passwordNotTheSame:
            "Password and confirm password are not the same!"
        case .emailAlreadyInUse:
            "Invalid email. This email is already in use!"
        case .wrongPassword:
            "You've entered a wrong password. Please try again!"
        case .networkError:
            "There was a network error. Please try again!"
        case .usernameLength:
            "Username should have between 3-24 characters"
        }
    }
}
