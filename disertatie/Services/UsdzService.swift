//
//  UsdzService.swift
//  disertatie
//
//  Created by Bontaș Robert on 06.04.2024.
//

import Foundation
import FirebaseFirestore

@Observable // to listen to changes
final class UsdzService{
    //Singleton
    static let sharedInstance = UsdzService()
    //reference to the usdz collection
    private let usdzsCollection = Firestore.firestore().collection("usdzs")
    //reference to a usdz document(record) in database
    private func getUsdzDocument(usdzId:String) -> DocumentReference {
         return usdzsCollection.document(usdzId)
    }
    
    func getUsdzModel(usdzId: String) async throws -> UsdzModel {
        try await getUsdzDocument(usdzId: usdzId).getDocument(as: UsdzModel.self)
    }
    
    func getRecords() async throws -> QuerySnapshot {
        let usdzsDocuments = try await usdzsCollection.getDocuments()
        return usdzsDocuments
    }
}
