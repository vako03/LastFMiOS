//
//  Model.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 22.07.23.
//

import Foundation


struct MusicData: Decodable {
    let musics: [Musics]
    
    private enum CodingKeys: String, CodingKey {
        case musics = "results"
    }
}

struct Musics: Decodable {
    
    let title: String?
    let rate: Double?
    let posterImage: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case rate = "vote_average"
        case posterImage = "poster_path"
    }
}
