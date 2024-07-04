//
//  UsdzModel.swift
//  disertatie
//
//  Created by Bontaș Robert on 06.04.2024.
//

import Foundation

class UsdzModel:Codable,Hashable{
    //So i can iterate a array of those
    static func == (lhs: UsdzModel, rhs: UsdzModel) -> Bool {
        return lhs.usdzId == rhs.usdzId
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(usdzId)
    }

    let usdzId:String
    let name:String?
    let category:String?
    let description:String?
    let modelURL:String?
    let thumbnailURL:String?
    let productURL:String?
    
    init(usdzId: String, name: String?, category: String?, description: String?, modelURL: String?, thumbnailURL: String?, productURL: String?) {
        self.usdzId = usdzId
        self.name = name
        self.category = category
        self.description = description
        self.modelURL = modelURL
        self.thumbnailURL = thumbnailURL
        self.productURL = productURL
    }
}
