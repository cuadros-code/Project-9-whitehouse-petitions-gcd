//
//  petition.swift
//  Project-7-whitehouse-petitions
//
//  Created by Kevin Cuadros on 15/08/24.
//

import Foundation


struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
