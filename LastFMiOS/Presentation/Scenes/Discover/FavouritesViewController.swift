//
//  FavouritesViewController.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//

import UIKit

class EventsViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var musics = [Musics]()
    private var apiService = ApiService()
    private var viewMoel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DiscoverCell", bundle: nil), forCellWithReuseIdentifier: DiscoverCell.identifier)
        loadDiscoevrMusicsData()
        
    }
    
    @IBAction func openMars(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "FavouritesViewController", bundle: nil)
        let marsVC = storyboard.instantiateViewController(withIdentifier: "TicketViewController") as! TicketViewController
        navigationController?.pushViewController(marsVC, animated: true)
        
    }
    
    
    private func loadDiscoevrMusicsData() {
        fetchDiscoverMusicsData { [weak self] in
            self?.collectionView.dataSource = self
            self?.collectionView.delegate = self
            self?.collectionView.reloadData()
        }
    }
    func fetchDiscoverMusicsData(completion: @escaping () -> ()) {
        
        apiService.getDiscoverData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.musics = listOf.musics
                completion()
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
}


extension EventsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        musics.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCell.identifier, for: indexPath) as! DiscoverCell
        
        let music = musics[indexPath.row]
        cell.setCellWithValuesOf(music)
        
        cell.animateImage()
        
        return cell
    }
}


extension EventsViewController: UICollectionViewDelegate {
}

extension EventsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 180, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}
