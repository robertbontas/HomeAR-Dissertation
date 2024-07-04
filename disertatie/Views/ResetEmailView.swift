//
//  ResetEmailView.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.03.2024.
//

import SwiftUI

struct ResetEmailView: View {
    @Bindable var settingsViewModel : SettingsViewModel
    var body: some View {
        VStack{
            Text("Current mail: \(settingsViewModel.userEmail)")
                .font(.headline)
            Text("After confirming, you will receive an confirming mail. Please click the link to make changes to your account.")
                .font(.subheadline)
            // RESET EMAIL FIELD
            TextField("Desired mail address", text: $settingsViewModel.resetEmail)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .foregroundStyle(.primary)
                .background{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .stroke(.primary,style: StrokeStyle(lineWidth:1))
                }
            // RESET EMAIL BUTTON
            Button{
                Task{
                    do{
                        try await settingsViewModel.resetUserEmail()
                    }
                    catch{
                        print("error on email change")
                    }
                }
            }label:{
                Text("Change mail")
                    .frame(height:55)
                    .frame(maxWidth:.infinity)
                    .bold()
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.orange)
                    }
            }
        }
        .padding()
        .sheet(isPresented:$settingsViewModel.showError){
            ErrorView(errorDescription: $settingsViewModel.errorMessage)
                .presentationDetents([.fraction(0.3)])
        }
    }
}

#Preview {
    ResetEmailView(settingsViewModel: SettingsViewModel())
}
