//
//  DesAIgnView.swift
//  disertatie
//
//  Created by Bontaș Robert on 19.04.2024.
//

import SwiftUI
import OpenAIKit

//vm
final class AiViewModel:ObservableObject{
    private var openai: OpenAI?
    func setup(){
        /*
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_SECRET_KEY"] else {
            fatalError("OPENAI_API_KEY environment variable not set")
        }
        guard let organization = ProcessInfo.processInfo.environment["OPENAI_API_ORGANIZATION"] else {
            fatalError("OPENAI_API_ORGANIZATION environment variable not set")
        }*/
        openai = OpenAI(Configuration(organizationId: "Personal", apiKey: ""))
    }
    
    func generateImage(prompt: String) async -> UIImage?{
        guard let openai = openai else{
            return nil
        }
        do{
            let params = ImageParameters(prompt: prompt, resolution: .medium, responseFormat: .base64Json)
            let result = try await openai.createImage(parameters: params)
            //decode result
            let data = result.data[0].image //image string format
            let image = try openai.decodeBase64Image(data)
            return image
            
        }catch{
            print(String(describing: error))
            return nil
        }
    }
}

struct DesAIgnView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = AiViewModel()
    @State var prompt = ""
    @State var generatedImage: UIImage?
    @State private var showCheckmarkPhotoSavedLocally = false
    @State private var isLoading = false
    
    var body: some View {
        VStack{
            HStack{
                Button(role: .cancel){
                    dismiss()
                }label:{
                    Image(systemName:"arrowshape.left.circle")
                        .imageScale(.large)
                        .foregroundStyle(Color(uiColor: .label))
                    Spacer()
                    Text("desAIgn - a AI Design Maker")
                        .font(.subheadline)
                        .bold()
                    Spacer()
                }
                Spacer()
            }
            .padding()
            if let image = generatedImage{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350,height: 350)
                
                Button(action: {
                    Task{
                        saveImageToPhotosAlbum(image:image)
                        withAnimation {
                            showCheckmarkPhotoSavedLocally = true
                        }
                    }
                }) {
                    if showCheckmarkPhotoSavedLocally {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    } else {
                        Text("Download")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            else {
                TextField("Type to generate. Ex: a yellow sofa in modern livingroom",text: $prompt)
                    .padding()
                Button("Generate desired instruction") {
                    if !prompt.trimmingCharacters(in: .whitespaces).isEmpty{
                        isLoading = true
                        Task {
                            let result = await viewModel.generateImage(prompt: prompt)
                            self.generatedImage = result
                            isLoading = false
                        }
                    }
                }
                .buttonStyle(CustomButtonStyle())
                .padding()
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            Spacer()
        }
        .padding()
        .onAppear{
            viewModel.setup()
        }
    }
    
    func saveImageToPhotosAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

#Preview {
    DesAIgnView()
}
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(Color(hex: "5B507A"))
            .cornerRadius(10)
            .padding()
            .foregroundColor(.white)
    }
}
