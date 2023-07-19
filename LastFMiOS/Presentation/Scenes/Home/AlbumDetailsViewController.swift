//
//  AlbumDetailsViewController.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 20.07.23.
//
import UIKit

class AlbumDetailsViewController: UIViewController {
    private let album: Album
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let albumImageView = UIImageView()
    private let albumNameLabel = UILabel()
    private let artistNameLabel = UILabel()
    private var overviewLabel = UILabel()
    private var releaseDateLabel = UILabel()
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupViews()
        configureAlbumDetails()
        fetchAlbumDetailsFromAPI()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    
    private func setupViews() {
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.contentMode = .scaleAspectFit
        view.addSubview(albumImageView)
        NSLayoutConstraint.activate([
            albumImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            albumImageView.widthAnchor.constraint(equalToConstant: 200),
            albumImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        albumNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        albumNameLabel.textAlignment = .center
        view.addSubview(albumNameLabel)
        NSLayoutConstraint.activate([
            albumNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            albumNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            albumNameLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 20)
        ])
        
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.textAlignment = .center
        view.addSubview(artistNameLabel)
        NSLayoutConstraint.activate([
            artistNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            artistNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 10)
        ])
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.numberOfLines = 0
        overviewLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(overviewLabel)
        NSLayoutConstraint.activate([
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            overviewLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 20)
        ])
        
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(releaseDateLabel)
        NSLayoutConstraint.activate([
            releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            releaseDateLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 10)
        ])
        
        
    }
    
    private func configureAlbumDetails() {
        
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
    
    private func fetchAlbumDetailsFromAPI() {
        guard let apiKey = "8a0e338471e81bb0dffeaa37600d414b".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let artistName = album.artist.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let albumName = album.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        let urlString = "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=\(apiKey)&artist=\(artistName)&album=\(albumName)&format=json"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching album details: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(AlbumDetailsResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.updateAlbumDetails(result)
                }
            } catch {
                print("Error decoding album details response: \(error)")
            }
        }.resume()
    }
    
    private func updateAlbumDetails(_ response: AlbumDetailsResponse) {
        // Update the UI elements with the fetched album details
        overviewLabel.text = response.album.wiki.summary
        releaseDateLabel.text = "Release Date: \(response.album.wiki.published)"
        
    }
    

}

struct AlbumDetailsResponse: Codable {
    struct Album: Codable {
        struct Wiki: Codable {
            let summary: String
            let published: String
        }
        
        let wiki: Wiki
        let listeners: String
        let playcount: String
    }
    
    let album: Album
}
