//
//  UploadedPhotoView.swift
//  disertatie
//
//  Created by Bontaș Robert on 01.04.2024.
//

import SwiftUI
import UIKit

struct UploadedPhotoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
     
    var body: some View {
        VStack{
            HStack{
                Button(role: .cancel){
                    dismiss()
                }label:{
                    Image(systemName:"xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(Color(uiColor: .label))
                }
                Spacer()
                Text("Uploaded-Photo Scenario")
                    .font(.subheadline)
                    .bold()
                Spacer()

            }
        }
        .padding()
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.main.bounds.height / 2)
            } else {
                Button("Select Photo") {
                    // Show image picker
                    presentationMode.wrappedValue.dismiss() // Dismiss current view to avoid overlay issues
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
                .sheet(isPresented: Binding<Bool>(get: {
                    selectedImage == nil
                }, set: { _ in })) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }
            // Add your horizontal slider of multiple images here
        }
        .padding()
        Spacer()
    }
    
}

// For image picking
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

