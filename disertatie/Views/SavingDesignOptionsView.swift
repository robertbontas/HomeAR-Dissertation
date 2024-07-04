//
//  SavingDesignOptionsView.swift
//  disertatie
//
//  Created by Bontaș Robert on 10.04.2024.
//

import SwiftUI

struct SavingDesignOptionsView: View {
    @EnvironmentObject var realTimeCameraViewModel: RealTimeCameraViewModel
    @Environment(\.dismiss) var dismiss
    @State private var localDesignName = ""
    @State private var designName: String = ""
    @State private var showCheckmarkPhotoSavedLocally = false
    @State private var showCheckmarkPhotoSavedOnCloud = false
    var body: some View {
        VStack{
            // START OF DISMISS BUTTON AND TITLE OF THE SHEET
            HStack{
                Button(role: .cancel){
                    //resume scene instance
                    ArSceneInstance.sharedInstance.resumeSceneInstance()
                    dismiss()
                }label:{
                    Image(systemName:"xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(Color(uiColor: .label))
                }
                Spacer()
                Text("Saving the design")
                    .font(.subheadline)
                    .bold()
                Spacer()
            }
            Spacer()
            VStack{
                Button(action: {
                    Task{
                        do {
                            // Capture a snapshot of the AR scene
                            await ArSceneInstance.sharedInstance.captureSnapshot { image in
                                // Save the captured image to the photo library if available
                                if let capturedImage = image {
                                    ArSceneInstance.sharedInstance.saveImageToPhotoLibrary(image: capturedImage)
                                    withAnimation {
                                        showCheckmarkPhotoSavedLocally = true
                                    }
                                } else {
                                    // Handle error if capturing snapshot fails
                                    print("DEBUG: Unable to save snapshot")
                                }
                            }
                        }
                    }
                }) {
                    if showCheckmarkPhotoSavedLocally {
                        Image(systemName: "checkmark")
                            .frame(height:65)
                            .frame(maxWidth:.infinity)
                            .foregroundColor(.white)
                            .tracking(1)
                            .bold()
                            .font(.system(size: 18))
                            .background{
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex:"5B507A"))
                            }
                    } else {
                        Text("Save design to phone gallery")
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
                }

                VStack{
                    TextField("Enter Design Name", text: $localDesignName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: localDesignName) { newValue in
                            realTimeCameraViewModel.designName = newValue
                        }
                    Button(action: {
                        // Action for the first button
                        // For example: realTimeCameraViewModel.saveDesign()
                        Task{
                            do {
                                try await ArSceneInstance.sharedInstance.saveDesignCloud(designName:realTimeCameraViewModel.designName)
                                withAnimation {
                                    showCheckmarkPhotoSavedOnCloud = true
                                }
                            }catch{
                                print("DEBUG it gets there -> \(error.localizedDescription)")
                                realTimeCameraViewModel.showDesignNameError = true
                                return
                            }
                        }

                    }) {
                        if showCheckmarkPhotoSavedOnCloud {
                            Image(systemName: "checkmark")
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
                        } else {
                            Text("Save design to account designs")
                                .frame(height:65)
                                .frame(maxWidth:.infinity)
                                .foregroundColor(.white)
                                .tracking(1)
                                .bold()
                                .font(.system(size: 18))
                                .background{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex:"5B507A"))
                                }
                        }
                    }
                }
                .padding()

            }
            .padding()
            .alert(isPresented: $realTimeCameraViewModel.showDesignNameError) {
                Alert(title: Text("Error"), message: Text("Failed to save design. It's name cannot be empty"), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        
    }
}


