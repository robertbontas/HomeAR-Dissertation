//
//  SignUpView.swift
//  disertatie
//
//  Created by Bontaș Robert on 30.03.2024.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @State var signUpViewModel = SignUpViewModel()
    var body: some View {
            Wave()
                .frame(height: 350)
                .foregroundColor(Color(hex: "5B507A"))
                .ignoresSafeArea()
        HStack{
            Button(role: .cancel){
                dismiss()
            }label:{
                Image(systemName:"xmark.circle")
                    .imageScale(.large)
                    .foregroundStyle(Color(uiColor: .label))
            }
            .padding()
            Spacer()
        }
        .offset(y: -150)
        
        Image("green_chair")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 250) // Adjust the height as needed
            .padding()
            .edgesIgnoringSafeArea(.top)
            .offset(y: -150)
            VStack{
                HStack{
                    Text("Register")
                        .offset(y:-180)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(hex:"5B507A"))
                }
                
                VStack(spacing:20){
                    //              E-MAIL FIELD
                    TextField("Email address", text: $signUpViewModel.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding()
                        .foregroundStyle(.primary)
                        .background{
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex:"EAF4F4"))
                                .stroke(.primary,style: StrokeStyle(lineWidth:3))
                                .foregroundColor(Color(hex:"5B507A"))
                        }
                    //              USERNAME FIELD
                    TextField("Username", text: $signUpViewModel.username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding()
                        .foregroundStyle(.primary)
                        .background{
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex:"EAF4F4"))
                                .stroke(.primary,style: StrokeStyle(lineWidth:3))
                                .foregroundColor(Color(hex:"5B507A"))
                        }
                    //              PASSWORD FIELD
                    SecureField("Password", text: $signUpViewModel.password)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding()
                        .foregroundStyle(.primary)
                        .background{
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex:"EAF4F4"))
                                .stroke(.primary,style: StrokeStyle(lineWidth:3))
                                .foregroundColor(Color(hex:"5B507A"))
                        }
                    //              CONFIRM PASSWORD
                    SecureField("Confirm password", text: $signUpViewModel.confirmPassword)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding()
                        .foregroundStyle(.primary)
                        .background{
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex:"EAF4F4"))
                                .stroke(.primary,style: StrokeStyle(lineWidth:3))
                                .foregroundColor(Color(hex:"5B507A"))
                        }
                    Button{
                        signUpViewModel.registerWithEmail()
                    }label:{
                        Text("Sign up now")
                            .frame(height:55)
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
                    
                }
                .offset(y: -180)
                Spacer()
            }
            .padding()
            .sheet(isPresented:$signUpViewModel.showError){
                ErrorView(errorDescription: $signUpViewModel.errorMessage)
                    .presentationDetents([.fraction(0.3)])
            }
        }
        
    }

        

#Preview {
    SignUpView()
}
