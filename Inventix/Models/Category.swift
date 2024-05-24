//
//  Category.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import Foundation

struct Category: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }
    
    init(id: UUID = UUID(), name: String, description: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
    }
}
