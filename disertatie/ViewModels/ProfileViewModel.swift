//
//  ProfileViewModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.03.2024.
//

import Foundation
import _PhotosUI_SwiftUI
//made as ObservableObject to use directly SwiftUI framework as @Observation from SettingsViewModel is a third-party framework integrated in SwiftUi
@MainActor //making it as main actor so i can still change published vars in main thread. because ERROR: Publishing changes from background threads is not allowed
final class ProfileViewModel:ObservableObject{
    @Published private(set) var user: UserModelFirestoreDatabase? = nil
    
    init(){
        
    }
    // function that will be called on appear of the view
    func loadUserData() async throws{
        let authDataOfUserFromAuthenticationState = try AuthService.sharedInstance.getAuthenticatedUser()
        self.user = try await UserService.sharedInstance.getUser(userId: authDataOfUserFromAuthenticationState.uid)
    }
    //function for saving profile image
    func saveProfileImage(item: PhotosPickerItem) async  {
        guard let user else {return}
        Task{
            guard let data = try await item.loadTransferable(type: Data.self) else {return}
            // Convert UIImage to Data
            guard let image = UIImage(data: data) else { return }
            //Saving image in Storage
            let (path,_) = try await StorageService.sharedInstance.saveImage(image: image,userId: user.userId)
            //Getting it's url that gets created
            let url = try await StorageService.sharedInstance.getUrlForImage(path: path)
            //Updating user profile_imagePath
            try await UserService.sharedInstance.updateUserProfilePicturePath(userId: user.userId, path: url.absoluteString)
        }
    }
}
