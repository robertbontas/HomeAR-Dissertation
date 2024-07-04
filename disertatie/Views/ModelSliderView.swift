//
//  ModelSliderView.swift
//  disertatie
//
//  Created by Bontaș Robert on 08.04.2024.
//

import SwiftUI

struct ModelSliderView:View{
    //declaring the viewModel instance that holds the models
    @EnvironmentObject var realTimeCameraViewModel: RealTimeCameraViewModel
    var body:some View{

        //Models picker
        ScrollView(.horizontal,showsIndicators:false){
            HStack(spacing:30){
                if let models = realTimeCameraViewModel.usdzsArray{
                    ForEach(0 ..< models.count){
                        index in
                        Button(action:{
                            // setting the selectedModel
                            realTimeCameraViewModel.updateSelectedModel(to: models[index])
                            realTimeCameraViewModel.isPlacementEnabled = true
                        }){
                            if models[index].thumbnailURL != nil {
                                AsyncImage(url: URL(string: (models[index].thumbnailURL)!)){ phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .frame(height:80)
                                            .aspectRatio(1/1,contentMode: .fit)
                                            .background(Color.white)
                                            .cornerRadius(12)
                                    }else {
                                        ProgressView().progressViewStyle(.circular)
                                    }
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding(20)
        .background(Color(hex:"6B9080").opacity(0.6))
    }
}
