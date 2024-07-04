//
//  ForgotPasswordView.swift
//  disertatie
//
//  Created by Bontaș Robert on 30.03.2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Bindable var signInViewModel : SignInViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        VStack{
            HStack{
                Text("Forgot password")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button(role: .cancel){
                    dismiss()
                }label:{
                    Image(systemName:"xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(Color(uiColor: .label))
                }
            }
            TextField("Please enter your mail address", text: $signInViewModel.forgotPasswordEmail)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .foregroundStyle(.primary)
                .background{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .stroke(.primary,style: StrokeStyle(lineWidth:1))
                }
            Button{
                    signInViewModel.resetPassword()
                    dismiss()
            }label:{
                Text("Send instruction mail")
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
        .sheet(isPresented:$signInViewModel.showError){
            ErrorView(errorDescription: $signInViewModel.errorMessage)
                .presentationDetents([.fraction(0.3)])
        }

    }
}

#Preview {
    ForgotPasswordView(signInViewModel: SignInViewModel())
}
