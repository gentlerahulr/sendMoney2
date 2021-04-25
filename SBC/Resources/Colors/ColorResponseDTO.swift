//
//  ColorResponseDTO.swift
//  SBC
//

//

import Foundation

struct ColorResponceDTO: Codable {
    
    let themes: Themes?
    
    enum CodingKeys: String, CodingKey {
        case themes
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        themes = try values.decodeIfPresent(Themes.self, forKey: .themes)
        
    }
}
