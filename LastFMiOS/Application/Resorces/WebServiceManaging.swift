//
//  WebServiceManaging.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//

import Foundation

protocol WebServiceManaging {
    func get<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void)
}

class WebServiceManager: WebServiceManaging {
    func get<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
