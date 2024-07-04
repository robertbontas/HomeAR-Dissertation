//
//  ProfileView.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.01.2024.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    // for selecting profile pictures
    @State private var selectedPhoto: PhotosPickerItem? = nil
    //for loading to user photo to gets updated
    @State private var isLoading: Bool = false
    @State private var showUpdateUsername = false
    var body: some View {
        VStack(spacing:5){
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 7) {
                    Spacer()
                    Spacer()
                    if let user = profileViewModel.user {
                        if let username = user.username {
                            Text("\(username)")
                                .padding()
                                .bold()
                                .tracking(1)
                                .offset(y:50)
                                .foregroundColor(Color(hex:"EAF4F4"))
                                .font(.title)
                        }
                    }
                    //PROFILE IMAGE RENDERING
                    if profileViewModel.user?.profile_image_path != nil {
                        AsyncImage(url: URL(string:(profileViewModel.user?.profile_image_path)!)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color(hex:"#6B9080"), lineWidth: 14))
                                    .padding(10)
                            } else {
                                ProgressView().progressViewStyle(.circular)
                            }
                        }
                        .offset(y:50)
                    }

                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.7) // Adjust the fraction as needed
                .background(Color(hex:"6B9080"))
            }
            VStack(spacing:5){
                
                if let user = profileViewModel.user{
                    if let isUserPremium = user.isPremium {
                        HStack {
                            Spacer()
                            Text("Premium Member")
                                .padding()
                                .foregroundStyle(.primary)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: "EAF4F4"))
                                        .foregroundColor(Color(hex: "5B507A"))
                                )
                            Image(systemName: "star.fill") // Use "star.fill" for a premium icon
                                .foregroundColor(.yellow) // Customize the color if needed
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    }
                    else{
                        HStack {
                            Spacer()
                            Text("Non-Premium Member")
                                .padding()
                                .foregroundStyle(.primary)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: "EAF4F4"))
                                        .foregroundColor(Color(hex: "5B507A"))
                                )
                            Image(systemName: "star") // Use "star.fill" for a premium icon
                                .foregroundColor(.yellow) // Customize the color if needed
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    }
                    if let email = user.email{
                        HStack{
                            Image(systemName: "envelope")
                            Text("\(email)")
                                .padding()
                                .foregroundStyle(.primary)
                                .background{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex:"EAF4F4"))
                                        .foregroundColor(Color(hex:"5B507A"))
                                }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    }
                    if let date_created = user.date_created {
                        HStack{
                            Spacer()
                            Text("\(date_created)")
                                .padding()
                                .foregroundStyle(.primary)
                                .background{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex:"EAF4F4"))
                                        .foregroundColor(Color(hex:"5B507A"))
                                }
                            Image(systemName: "calendar")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    }

            }
                
                // PHOTO PICKER
                PhotosPicker(selection:$selectedPhoto,matching: .images,photoLibrary: .shared()){
                    Text("Edit profile picture")
                        .frame(height:55)
                        .frame(maxWidth:.infinity)
                        .foregroundColor(Color(hex:"EAF4F4"))
                        .tracking(1)
                        .bold()
                        .font(.system(size: 18))
                        .background{
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex:"0A2E36"))
                        }
                }
                .padding()
                // START ON CHANGE EVENT FOR CHANGING USER PHOTO
                .onChange(of: selectedPhoto, perform:{newValue in if let newValue{
                    Task{
                        do{
                            await profileViewModel.saveProfileImage(item: newValue)
                            //show loading
                            isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                Task {
                                    do {
                                        try await profileViewModel.loadUserData()
                                        
                                        // Hide loading screen
                                        isLoading = false
                                    } catch {
                                        print("Error reloading user data: \(error)")
                                    }
                                }
                            }
                        }
                    }
                }})
                // END ON CHANGE EVENT FOR CHANGING USER PHOTO
                
                // LOADING STATE SO PROFILE PICTURE CAN BE FETCHED
                if isLoading {
                    VStack {
                        ProgressView()
                            .padding()
                        Text("Loading, profile picture is on the way!")
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    .frame(width: 350, height: 120)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .zIndex(2) // Ensure loading screen appears above other content
                    .padding(.vertical,50)
                }
                // END OF LOADING STATE SO PROFILE PICTURE CAN BE FETCHED
                
                //CHANGING USER USERNAME
                Button{
                    // Show the alert
                    showUpdateUsername = true
                }label:{
                    Text("Change username")
                        .frame(height:55)
                        .frame(maxWidth:.infinity)
                        .foregroundColor(Color(hex:"EAF4F4"))
                        .tracking(1)
                        .bold()
                        .font(.system(size: 18))
                        .background{
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex:"0A2E36"))
                        }
                }
                .offset(y:-25)
                .padding()
                Spacer()
                // SHEET FOR USER CHANGING USERNAME
                // ON DISMISS RELOAD VIEW
                .sheet(isPresented: $showUpdateUsername, onDismiss: {
                    Task {
                        do {
                            try await profileViewModel.loadUserData()
                        } catch {
                            // Handle error reloading user data
                            print("Error reloading user data: \(error)")
                        }
                    }
                }) {
                    VStack {
                        UpdateUsernameView()
                    }
                    .presentationDetents([.height(400), .medium, .large])
                    .presentationDragIndicator(.automatic)
                    
                }
            }
            
        }
        .task{
            try? await profileViewModel.loadUserData()
        }
    }
    
    
}
