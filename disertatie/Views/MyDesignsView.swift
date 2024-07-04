//
//  MyDesignsView.swift
//  disertatie
//
//  Created by Bontaș Robert on 17.04.2024.
//

import SwiftUI

struct MyDesignsView: View {
    @StateObject var myDesignViewModel = MyDesignViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            VStack{
                // START OF DISMISS BUTTON AND TITLE OF THE SHEET
                HStack{
                    Button(role: .cancel){
                        dismiss()
                    }label:{
                        Image(systemName:"arrowshape.left.circle")
                            .imageScale(.large)
                            .foregroundStyle(Color(uiColor: .label))
                    }
                    Spacer()
                    Text("My saved designs")
                        .font(.subheadline)
                        .bold()
                        .padding()
                    Spacer()
                }
                .padding()
                // END OF DISMISS BUTTON AND TITLE OF THE SHEET
                if myDesignViewModel.userDesigns.isEmpty {
                    Text("No designs")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(myDesignViewModel.userDesigns, id: \.id) { design in
                            NavigationLink(destination: DesignDetailView(design: design).environmentObject(myDesignViewModel)) {
                                DesignItemInList(design: design)
                            }
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 5)
                                    .background(.white)
                                    .foregroundColor(Color(hex:"A4C3B2"))
                                    .padding(
                                        EdgeInsets(
                                            top: 10,
                                            leading: 10,
                                            bottom: 2,
                                            trailing: 10
                                        )
                                    )
                                    
                            )
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { indexSet in
                            myDesignViewModel.deleteDesign(at: indexSet.first ?? 0)
                        }
                        
                    }
                    .background(.white)
                    .scrollContentBackground(.hidden)
                    
                }
                
                
                
            }
            .padding()
            Spacer()

        }.onAppear{myDesignViewModel.fetchDesigns()
    }
}

}


    //list design item
struct DesignItemInList:View{
    let design:DesignModel
    var body:some View{
        //Design list item
        HStack{
            //Design Image
            AsyncImage(url: design.designUrl){ phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .frame(height:60)
                        .frame(width :60)
                        .aspectRatio(1/1,contentMode: .fit)
                        .background(Color.white)
                        .cornerRadius(12)
                }else {
                    ProgressView().progressViewStyle(.circular)
                }
            }
            
            VStack{
                Text(design.designName)
                    .foregroundColor(Color(hex:"5B507A"))
                    .font(.title)
                    .frame(maxWidth: .infinity) // Ensure the text takes the full width
                    .multilineTextAlignment(.center) // Center align the text
                Text(design.dateCreated)
                    .foregroundColor(Color(hex:"EAF4F4"))
                    .font(.footnote)
                    .tracking(2)
            }
            .padding()
        }
    }
}
