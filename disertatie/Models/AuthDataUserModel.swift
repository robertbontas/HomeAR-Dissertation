//
//  AuthDataUserModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.03.2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel{
    let uid:String
    /* with ? because it is optional if i'm trying to login in other way*/
    let email:String?
    let username:String?
    
    /*To make it cleaner, rather than call it everytime to convert from authDataResultModel i'll do like that, user:User because that's the type the information comes from AuthDataResult from .createUser function:*/
    init(user:User){
        self.uid = user.uid
        self.email = user.email
        self.username = user.displayName
    }
}
