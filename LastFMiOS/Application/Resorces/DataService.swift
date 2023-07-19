//
//  DataService.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//

import Foundation


class DataService {
    private let webServiceManaging: WebServiceManaging
    
    init(webServiceManaging: WebServiceManaging) {
        self.webServiceManaging = webServiceManaging
    }
    
    func fetchTags(completion: @escaping (Result<[Tag], Error>) -> Void) {
        let url = "https://ws.audioscrobbler.com/2.0/?method=tag.getTopTags&api_key=8a0e338471e81bb0dffeaa37600d414b&format=json"
        webServiceManaging.get(url: url) { (result: Result<TopTagsResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.toptags.tag))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAlbums(url: String, completion: @escaping (Result<[Album], Error>) -> Void) {
        webServiceManaging.get(url: url) { (result: Result<AlbumsResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.albums.album))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
class ApiService {
    private var dataTask: URLSessionDataTask?
    
    
    func getDiscoverData(completion: @escaping (Result<MusicData, Error>) -> Void) {
        
        let discoverMusicsURL = "https://run.mocky.io/v3/374378b8-30b4-44e7-93c5-dfe41057b125"
        
        guard let url = URL(string: discoverMusicsURL) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MusicData.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
        
    }
    
}

