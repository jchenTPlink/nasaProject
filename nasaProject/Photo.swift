//
//  Photo.swift
//  nasaProject
//
//  Created by Jonathan Chen on 10/8/24.
//

import Foundation


// I see ObjectMapper is used in other TP-Link apps...
class Photo: Decodable {
    
    var id: Int
    var imageSource: String
    var earthDate: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageSource = "img_src"
        case earthDate = "earth_date"
    }
    
}

class PhotoList: Decodable {
    var photos: [Photo]
}

