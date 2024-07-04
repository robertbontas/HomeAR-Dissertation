//
//  DesignModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 17.04.2024.
//

import Foundation
import FirebaseFirestore

struct DesignModel:Codable,Identifiable{
    @DocumentID var id: String?
    var userId: String
    var designName: String
    var dateCreated: String
    var designUrl: URL
    var modelsId: [String]
}
