//
//  CreatureModel.swift
//  CatchEmAll
//
//  Created by Tushar Munge on 7/9/25.
//

import Foundation

struct CreatureModel: Codable, Identifiable {
    let id = UUID().uuidString
    
    var name: String
    var url : String // URL for detail on Pokemon
    
    enum CodingKeys: CodingKey {
        case name
        case url
    }
}
