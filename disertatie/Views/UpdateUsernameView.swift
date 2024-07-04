//
//  UpdateUsernameView.swift
//  disertatie
//
//  Created by Bontaș Robert on 01.04.2024.
//

import SwiftUI

struct UpdateUsernameView: View {
    @State private var newUsername: String = ""
    @Environment(\.presentationMode) var presentationMode
    func submitUsername() {
        Task {
            do {
                try await UserService.sharedInstance.updateUsername(userId: AuthService.sharedInstance.getAuthenticatedUser().uid, newUsername: newUsername)
                // Dismiss the modal
                presentationMode.wrappedValue.dismiss()
            } catch {
                // Handle error
                print("Error updating username: \(error)")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Change your username")
                    .font(.system(size:32,weight:.bold))
                    
                TextField("Enter new username", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(maxWidth: 300)
                    .frame(height:40)
                    .foregroundStyle(Color.black)
                
                Button(action: {
                    submitUsername()
                }) {
                    Text("Submit")
                        .font(.system(size:22,weight:.bold))
                        .foregroundStyle(Color.white)
                        .frame(height:55)
                        .frame(maxWidth: 300)
                        .background(Color.blue)
                        .cornerRadius(10.0)
                }
                HStack {
                    Image(systemName: "info.circle") // Use systemName with the name of the SF Symbol
                        .foregroundColor(.blue) // Set the color of the icon
                    
                    Text("To dismiss, simply swipe down the pop-up!") // Your text here
                        .font(.headline) // Set the font of the text
                        .foregroundColor(.black) // Set the color of the text
                        .frame(maxWidth:300)
                }
                .padding()
            }
        }
    }
}


