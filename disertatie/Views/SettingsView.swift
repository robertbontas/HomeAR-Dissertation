//
//  SettingsView.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.03.2024.
//

import SwiftUI

struct SettingsView: View {
    @State var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack(spacing: 7) {
                    
                    // RESET PASSWORD BUTTON
                    Button(action: {
                        settingsViewModel.showResetPassword = true
                    }) {
                        Text("Reset password")
                            .frame(height:65)
                            .frame(maxWidth:.infinity)
                            .foregroundColor(Color(hex:"5B507A"))
                            .tracking(1)
                            .bold()
                            .font(.system(size: 18))
                            .background{
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex:"EAF4F4"))
                            }
                    }
                    .padding()
                    
                    // RESET EMAIL BUTTON
                    Button(action: {
                        settingsViewModel.showResetEmail = true
                    }) {
                        Text("Reset Email")
                            .frame(height:65)
                            .frame(maxWidth:.infinity)
                            .foregroundColor(.white)
                            .tracking(1)
                            .bold()
                            .font(.system(size: 18))
                            .background{
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex:"A4C3B2"))
                            }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.7) // Adjust the fraction as needed
                .background(Color(hex: "5B507A"))
            }
            
            // SIGN OUT BUTTON
            Button(action: {
                settingsViewModel.signUserOut()
            }) {
                Text("Sign out")
                    .frame(height:65)
                    .frame(maxWidth:.infinity)
                    .foregroundColor(.white)
                    .tracking(1)
                    .bold()
                    .font(.system(size: 18))
                    .background{
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex:"A4C3B2"))
                    }
            }
            .padding()
            .offset(y:-100)
            
            // DELETE ACCOUNT BUTTON
            Button(action: {
                settingsViewModel.showDeleteConfirmation = true
            }) {
                Text("Delete account")
                    .frame(height:65)
                    .frame(maxWidth:.infinity)
                    .foregroundColor(Color(hex:"EAF4F4"))
                    .tracking(1)
                    .bold()
                    .font(.system(size: 18))
                    .background{
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex:"5B507A"))
                    }
            }
            .padding()
            .offset(y:-100)
        }
        .onAppear {
            settingsViewModel.fetchUserEmail()
        }
        .sheet(isPresented: $settingsViewModel.showResetPassword) {
            ConfirmResetPasswordView(settingsViewModel: settingsViewModel)
                .presentationDetents([.fraction(0.3)])
        }
        .sheet(isPresented: $settingsViewModel.showResetEmail) {
            ResetEmailView(settingsViewModel: settingsViewModel)
                .presentationDetents([.fraction(0.4)])
        }
        .alert(isPresented: $settingsViewModel.showDeleteConfirmation) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone. You will be logged out after confirming deletion."),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        do {
                            try await settingsViewModel.deleteAccount()
                            settingsViewModel.signUserOut()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}
