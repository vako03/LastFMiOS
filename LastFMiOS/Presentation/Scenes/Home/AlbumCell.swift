//
//  AlbumCell.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//


import UIKit
class AlbumCell: UICollectionViewCell {
    private let albumImageView = UIImageView()
    private let albumNameLabel = UILabel()
    private let artistNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.contentMode = .scaleAspectFit
        addSubview(albumImageView)
        NSLayoutConstraint.activate([
            albumImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            albumImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 80),
            albumImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(albumNameLabel)
        NSLayoutConstraint.activate([
            albumNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10),
            albumNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            albumNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(artistNameLabel)
        NSLayoutConstraint.activate([
            artistNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10),
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 5),
            artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func configure(with album: Album) {
        albumNameLabel.text = album.name
        artistNameLabel.text = album.artist.name
        
        if let imageURLString = album.image.first(where: { $0.size == "extralarge" })?.text,
           let imageURL = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                if let error = error {
                    print("Error loading album image: \(error)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.albumImageView.image = image
                    }
                }
            }.resume()
        }
    }
}
