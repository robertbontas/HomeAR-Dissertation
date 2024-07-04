//
//  DesignDetailView.swift
//  disertatie
//
//  Created by Bontaș Robert on 18.04.2024.
//

import SwiftUI

struct DesignDetailView: View {
    let design: DesignModel
    @EnvironmentObject var myDesignViewModel: MyDesignViewModel
    var body: some View {
        VStack{
            //Design Image
            AsyncImage(url: design.designUrl){ phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.main.bounds.height / 2)
                        .clipped()
                }else {
                    ProgressView().progressViewStyle(.circular)
                }
            }
            VStack(spacing: 5) {
                Text(design.designName)
                    .font(.title)
                Text(design.dateCreated)
                    .foregroundColor(.secondary)
            }
            .padding()
            Text("Objects used in design:")
            List(myDesignViewModel.selectedDesignModels, id: \.usdzId) { model in
                NavigationLink(destination: ModelDetailView(model:model)) {
                    // Content for each row in the list
                    ModelItemInList(model: model)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 5)
                        .background(.opacity(0.3))
                        .foregroundColor(.gray)
                        .padding(
                            EdgeInsets(
                                top: 2,
                                leading: 10,
                                bottom: 2,
                                trailing: 10
                            )
                        )
                )
                .listRowSeparator(.hidden)
            }
            .background(.white)
            .scrollContentBackground(.hidden)
            Spacer()
        }
        .onAppear {
            myDesignViewModel.selectedDesignModels = []
            myDesignViewModel.fetchDesignModels(modelsIds: design.modelsId)
        }
    }
    
    
}


struct ModelItemInList:View{
    let model:UsdzModel
    var body:some View{
        //Design list item
        HStack{
            //Design Image
            if let thumbnailURLString = model.thumbnailURL, let thumbnailURL = URL(string: thumbnailURLString) {
                AsyncImage(url: thumbnailURL){ phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(height:100)
                            .frame(width :100)
                            .aspectRatio(1/1,contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                    }else {
                        ProgressView().progressViewStyle(.circular)
                    }
                }
            }
            
            VStack{
                Text(model.name!)
                    .foregroundColor(.black)
                    .font(.title)
                Text("Category: \(model.category!)")
                    .foregroundColor(.black)
            }
            .padding()
        }
    }
}
