//
//  MyDesignViewModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 17.04.2024.
//

import Foundation
@MainActor
final class MyDesignViewModel:ObservableObject{
    @Published var userDesigns: [DesignModel] = []
    @Published var selectedDesignModels: [UsdzModel] = []
    func fetchDesigns(){
        let userId = AuthService.sharedInstance.currentUser?.uid
        //making the query in db and get results as QuerySnapshot
        DesignService.sharedInstance.fetchUserDesigns(userId: userId!) { documents, error in
            if error != nil {
                // Handle error
                self.userDesigns = []
                return
            }
            
            guard let documents = documents else {
                //no documents found
                self.userDesigns = []
                return
            }
            //convert from queryDocSnapshot to DesignModel
            let designs = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: DesignModel.self)
            }
            self.userDesigns = designs
            print("DEBUG: userdesigns loaded #\(self.userDesigns.count)")
        }
    }
    func deleteDesign(at index: Int) {
        // Delete the designs at the specified offsets from the userDesigns array
        let designToRemove = self.userDesigns[index]
        print("DEBUG: design to be removed name: \(designToRemove.designName) with id: \(designToRemove.id)" )
        DesignService.sharedInstance.deleteDesignById(designId:designToRemove.id!, uid:AuthService.sharedInstance.getCurrentUserUid())
    }
    func fetchDesignModels(modelsIds: [String]){
        print("DEBUG models id \(modelsIds)")
        //loop in string id's 
        Task {
            for usdzId in modelsIds {
                do {
                    let usdzModel = try await UsdzService.sharedInstance.getUsdzModel(usdzId: usdzId)
                    // Append the fetched UsdzModel to the array
                    self.selectedDesignModels.append(usdzModel)
                } catch {
                    print("Error fetching UsdzModel for usdzId \(usdzId): \(error.localizedDescription)")
                }
            }
        }
    }
}
