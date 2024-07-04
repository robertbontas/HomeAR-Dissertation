//
//  UserModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.03.2024.
//

import Foundation
import FirebaseFirestore

struct UserModelFirestoreDatabase:Codable{
    //attributes that will be stored in Firestore document of the UserModel
    let userId:String
    let username:String?
    let email:String?
    let profile_image_path : String?
    let date_created : String?
    let isPremium: Bool?
    
    //constructors of that model:
    
    //constructor using only AuthDataResultModel (output of Firebase methods)
    init(auth: AuthDataResultModel){
        self.userId = auth.uid
        self.username = auth.username
        self.email = auth.email
        self.date_created = ""
        self.profile_image_path = nil
        self.isPremium = false
    }
    //CUSTOM: constructor using also dateGiven for date_created and profileImagePath for profile_image_path
    init(auth: AuthDataResultModel, dateGiven: String,profileImagePath:String? = nil){
        self.userId = auth.uid
        self.username = auth.username
        self.email = auth.email
        self.date_created = dateGiven
        self.profile_image_path = profileImagePath
        self.isPremium = false
    }
}
