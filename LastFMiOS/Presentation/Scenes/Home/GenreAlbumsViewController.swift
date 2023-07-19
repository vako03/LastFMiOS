//
//  GenreAlbumsViewController.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//

import UIKit


class GenreAlbumsViewController: UIViewController {
    private var albums: [Album]
    private let reuseIdentifier = "AlbumCell"
    private var collectionView: UICollectionView!
    
    init(albums: [Album]) {
        self.albums = albums
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth
        let itemHeight: CGFloat = 150
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
    }
}

extension GenreAlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCell
        let album = albums[indexPath.item]
        cell.configure(with: album)
        return cell
    }
}

extension GenreAlbumsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAlbum = albums[indexPath.item]
        let albumDetailsViewController = AlbumDetailsViewController(album: selectedAlbum)
        navigationController?.pushViewController(albumDetailsViewController, animated: true)
     
    }
}
