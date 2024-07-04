//
//  LandingPageArView.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.03.2024.
//

import SwiftUI
final class LandingPageViewModel:ObservableObject{
    @Published var isUserPremium: Bool?
    
    func checkIsUserPremium() async throws{
        //getting user id from auth state
        let uid = AuthService.sharedInstance.currentUser?.uid
        let user = try await UserService.sharedInstance.getUser(userId: uid!)
        DispatchQueue.main.async {
            self.isUserPremium = user.isPremium
        }
    }
}
struct LandingPageArView: View {
    @State private var isPresentingRealTimeCameraView = false
    @State private var isPresentingUploadedPhotoView = false
    @State private var isPresentingMyDesignView = false
    @ObservedObject var landingPageViewModel = LandingPageViewModel()
    var body: some View {
        VStack(spacing: 20) {
            //child1
            Button(action: {
                isPresentingRealTimeCameraView = true
            }) {
                    Text("AR Real-Time Placement")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color(hex:"A4C3B2"))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding()

            }
            
            //child2
            Button(action: {
                isPresentingUploadedPhotoView = true
            }) {
                Text("DesAIgn (AI design generator for our premium members)")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(Color(hex: "5B507A"))
                    .cornerRadius(10)
                    .padding()
                    .foregroundColor(.white)
            }
            .disabled(landingPageViewModel.isUserPremium == false)
            .foregroundColor(landingPageViewModel.isUserPremium == false ? Color.gray : Color.primary)
            //child3
            Button(action: {
                isPresentingMyDesignView = true
            }) {
                    Text("Saved Designs")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .background(Color(hex:"6B9080"))
                        .cornerRadius(10)
                        .padding()
                        .foregroundColor(.white)

            }
        }
        .onAppear {
            Task {
                do {
                    try await landingPageViewModel.checkIsUserPremium()
                } catch {
                    print("Error checking user premium status: \(error)")
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentingRealTimeCameraView) {
            RealTimeCameraView()
        }
        .fullScreenCover(isPresented: $isPresentingUploadedPhotoView) {
            DesAIgnView()
        }
        .fullScreenCover(isPresented: $isPresentingMyDesignView) {
            MyDesignsView()
        }
    }
}




