//  ViewModel.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 22.07.23.
//

import Foundation


class ViewModel {
    
    private var apiService = ApiService()
    private var discoverMusics = [Musics]()
    
    func fetchDiscoverMusicsData(completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        apiService.getDiscoverData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.discoverMusics = listOf.musics
                completion()
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        discoverMusics.count
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Musics {
        return discoverMusics[indexPath.row]
    }
}
