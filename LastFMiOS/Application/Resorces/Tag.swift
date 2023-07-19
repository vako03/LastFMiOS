//
//  Tag.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//

import Foundation

struct TopTagsResponse: Codable {
    let toptags: TopTags
    
    struct TopTags: Codable {
        let tag: [Tag]
    }
}

struct Tag: Codable {
    let name: String
    let count: Int
    let reach: Int
}

struct AlbumsResponse: Codable {
    let albums: TopAlbums
    
    struct TopAlbums: Codable {
        let album: [Album]
    }
}

struct Album: Codable {
    let name: String
    let mbid: String
    let url: String
    let artist: Artist
    let image: [AlbumImage]
    
    struct Artist: Codable {
        let name: String
        let mbid: String
        let url: String
    }
    
    struct AlbumImage: Codable {
        let text: String
        let size: String
        
        enum CodingKeys: String, CodingKey {
            case text = "#text"
            case size
        }
    }
}
