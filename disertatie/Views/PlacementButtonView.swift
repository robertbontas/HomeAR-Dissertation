//
//  PlacementButtonView.swift
//  disertatie
//
//  Created by Bontaș Robert on 08.04.2024.
//

import SwiftUI

//VIEW FOR PLACEMENT BUTTON
struct PlacementButtonView: View{
    //declaring the viewModel instance that holds the models
    @EnvironmentObject var realTimeCameraViewModel: RealTimeCameraViewModel
    var body: some View{
        HStack{
            //Cancel button
            Button(action:{
                self.resetPlacementParameter()
            }){
                Image(systemName: "xmark")
                    .frame(width: 60,height: 60)
                    .font(.title)
                    .background(Color.white).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    .cornerRadius(30)
                    .padding(20)
            }
            //Confirmation button
            Button(action:{
                realTimeCameraViewModel.updateConfirmSelectedModel(to: realTimeCameraViewModel.selectedModel!)
                Task{
                    await realTimeCameraViewModel.fetchModelEntityFromWeb()
                }
                self.resetPlacementParameter()
            }){
                Image(systemName: "checkmark")
                    .frame(width: 60,height: 60)
                    .font(.title)
                    .background(Color.white).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    .cornerRadius(30)
                    .padding(20)
            }

        }

    }
    func resetPlacementParameter(){
        realTimeCameraViewModel.isPlacementEnabled = false
        realTimeCameraViewModel.updateSelectedModel(to: nil)
    }
}
