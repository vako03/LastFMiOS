//
//  HomeViewController.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//

import UIKit

class HomeViewController: UIViewController {
    private var dataService: DataService!
    private var tags: [Tag] = []
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService = DataService(webServiceManaging: WebServiceManager())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        
        fetchData()
    }
    
    private func fetchData() {
        dataService.fetchTags { [weak self] result in
            switch result {
            case .success(let tags):
                self?.tags = tags
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching tags: \(error)")
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let tag = tags[indexPath.item]
        cell.configure(with: tag)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTag = tags[indexPath.item]
        let albumURL = "http://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=\(selectedTag.name)&api_key=8a0e338471e81bb0dffeaa37600d414b&format=json"
        
        dataService.fetchAlbums(url: albumURL) { [weak self] result in
            switch result {
            case .success(let albums):
                DispatchQueue.main.async {
                    let genreAlbumsViewController = GenreAlbumsViewController(albums: albums)
                    self?.navigationController?.pushViewController(genreAlbumsViewController, animated: true)
                }
            case .failure(let error):
                print("Error fetching albums: \(error)")
            }
        }
    }
}
