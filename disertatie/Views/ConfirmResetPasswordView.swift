//
//  ConfirmResetPasswordView.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.03.2024.
//

import SwiftUI

struct ConfirmResetPasswordView: View {
    @Bindable var settingsViewModel : SettingsViewModel
    var body: some View {
        VStack{
            Text("Confirm resetting password for account: \(settingsViewModel.userEmail).")
                .bold()
            Button{
                Task{
                    await settingsViewModel.resetUserPassword()
                    settingsViewModel.signUserOut()
                }
            }label:{
                Text("Reset password")
                    .frame(height:55)
                    .frame(maxWidth:.infinity)
                    .bold()
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.orange)
                    }
            }
            Text(" After confirming you will be logged out and receive a mail with instruction at that address.")
                .foregroundStyle(Color(.blue))
        }
        .padding()
    }
}

#Preview {
    ConfirmResetPasswordView(settingsViewModel: SettingsViewModel())
}
