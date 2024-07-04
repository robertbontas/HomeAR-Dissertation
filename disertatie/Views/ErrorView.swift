//
//  ErrorView.swift
//  disertatie
//
//  Created by Bontaș Robert on 31.03.2024.
//
import SwiftUI

struct ErrorView: View {
    @Binding var errorDescription: String
    var body: some View {
        VStack(spacing:20){
            Image(systemName: "xmark.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75, height: 75)
                .foregroundColor(.red)
            Text("Ooups... an error occured")
                .font(.title)
                .bold()
            Text("\(errorDescription)")
                .font(.subheadline)
                .lineLimit(nil) // allows the text to wrap to the next line
                .multilineTextAlignment(.leading)
        }
        .padding()
    }
        
}

struct ErrorView_Previews: PreviewProvider {
    @State static var errorDescription = "An error occurred"
    
    static var previews: some View {
        ErrorView(errorDescription: $errorDescription)
    }
}
