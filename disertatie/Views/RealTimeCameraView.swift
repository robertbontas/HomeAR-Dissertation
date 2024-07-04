//
//  RealTimeCameraView.swift
//  disertatie
//
//  Created by Bontaș Robert on 01.04.2024.
//

import SwiftUI
import RealityKit
import ARKit

struct RealTimeCameraView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var realTimeCameraViewModel = RealTimeCameraViewModel()
    var body: some View {
        VStack{
            // START OF DISMISS BUTTON AND TITLE OF THE SHEET
            HStack{
                Button(role: .cancel){
                    dismiss()
                }label:{
                    Image(systemName:"xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(Color(uiColor: .label))
                }
                Spacer()
                Text("Real-Time Scenario")
                    .font(.subheadline)
                    .bold()
                Spacer()
            }
            // END OF DISMISS BUTTON AND TITLE OF THE SHEET
            // AR VIEW
            ZStack(alignment:.bottom){
                ArLiveCameraView()
                //Button for taking snapshot
                //Take the snapshot and redirect me to another page
                HStack{
                    Spacer()
                    Button {
                        //freeze current scene
                        ArSceneInstance.sharedInstance.freezeSceneInstance()
                        //show saving options
                        realTimeCameraViewModel.showDesignSavingOption = true
                        
                    } label: {
                        Image(systemName: "camera")
                            .frame(width:60, height:60)
                            .font(.title)
                            .background(.white.opacity(0.75))
                            .cornerRadius(30)
                            .padding()
                            .foregroundColor(Color(hex:"6B9080"))
                    }
                }
            }
            // END OF AR VIEW
            // START Placement UI if placement is toggled:
            if realTimeCameraViewModel.isPlacementEnabled{
                PlacementButtonView()
            } else {
             //Model Slider View
                ModelSliderView() //sharing same instance of viewModel in both views
            }
            // END OF PLACEMENT UI
            
        }
        .environmentObject(realTimeCameraViewModel) //I am putting envObject here so that child views get access to it
        .padding()
        .onAppear {
            Task {
                do {
                    try await realTimeCameraViewModel.fetchModels()
                } catch {
                    print("Error fetching models: \(error.localizedDescription)")
                }
            }
        }
        .sheet(isPresented:$realTimeCameraViewModel.showDesignSavingOption){
            SavingDesignOptionsView()
                .presentationDetents([.fraction(0.4)])
                .environmentObject(realTimeCameraViewModel)
        }

        Spacer()

        
    }

    
}

