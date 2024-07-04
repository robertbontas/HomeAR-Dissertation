//
//  SignInView.swift
//  disertatie
//
//  Created by Bontaș Robert on 30.03.2024.
//

import SwiftUI

struct SignInView: View {
    @State var signInViewModel = SignInViewModel()
    
    var body: some View {
        
        Wave()
            .frame(height: 350)
            .foregroundColor(Color(hex: "6B9080"))
        Text("HomeAR")
            .offset(y:-150)
            .font(.largeTitle)
            .bold()
            .foregroundColor(Color(hex:"EAF4F4"))

        Image("home")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 250) // Adjust the height as needed
            .padding()
            .edgesIgnoringSafeArea(.top)
            .offset(y: -150)

        VStack(spacing:20){
            //              E-MAIL FIELD
            TextField("Email address", text: $signInViewModel.email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .foregroundStyle(.primary)
                .background{
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex:"EAF4F4"))
                        .stroke(.primary,style: StrokeStyle(lineWidth:3))
                        .foregroundColor(Color(hex: "6B9080"))
                }
            //              PASSWORD FIELD
            SecureField("Password", text: $signInViewModel.password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .foregroundStyle(.primary)
                .background{
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex:"EAF4F4"))
                        .stroke(.primary,style: StrokeStyle(lineWidth:3))
                        .foregroundColor(Color(hex: "6B9080"))
                }
            //                  FORGOT PASSWORD BUTTON
            Button("Forgot password ? Click here."){
                signInViewModel.showForgotPassword = true
            }.bold()
                .foregroundColor(Color(hex:"0A2E36"))
            //                  SIGN IN BUTTON
            Button{
                signInViewModel.signInWithEmail()
            }label:{
                Text("Sign in")
                    .frame(height:55)
                    .frame(maxWidth:.infinity)
                    .foregroundColor(Color(hex:"EAF4F4"))
                    .tracking(1)
                    .bold()
                    .font(.system(size: 18))
                    .background{
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex:"6B9080"))
                    }
            }
        }
        .offset(y:-160)
        .padding()
        Spacer()
        //                  REGISTER BUTTON
        VStack{
            Text("Don't have an account yet?")
                .bold()
                .foregroundColor(Color(hex:"0A2E36"))
            Button{
                signInViewModel.showRegistration = true
            }label:{
                Text("Register")
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
            
        }
        .offset(y:-180)

        .padding()
        .ignoresSafeArea()

        //                          CALL REGISTRATION SHEET
        .sheet(isPresented: $signInViewModel.showRegistration){
            SignUpView()
                .presentationDetents([.fraction(0.9)])
        }
        .sheet(isPresented:$signInViewModel.showForgotPassword){
            ForgotPasswordView(signInViewModel: signInViewModel)
                .presentationDetents([.fraction(0.3)])
        }
        .sheet(isPresented:$signInViewModel.showError){
            ErrorView(errorDescription: $signInViewModel.errorMessage)
                .presentationDetents([.fraction(0.3)])
        }
    }

}
struct Wave: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x:rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x:rect.maxX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control1: CGPoint(x: rect.maxX * 0.75, y: rect.midY), control2: CGPoint(x: rect.maxX*0.4, y: rect.maxY*1.5))
        path.closeSubpath()
        return path
    }
}
#Preview {
    SignInView()
}
