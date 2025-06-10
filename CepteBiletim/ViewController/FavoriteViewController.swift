//  FavoriteViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//


import UIKit

class FavoriteViewController: UIViewController {
    
    var favoriteCollectionView: UICollectionView!
    var favoriteEvent: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Favoriler"
        setupCollectionView()
        fetchFavoriteEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteEvents()
        favoriteCollectionView.reloadData()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 160)
        layout.minimumLineSpacing = 15
        
        favoriteCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favoriteCollectionView.backgroundColor = .white
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        
        view.addSubview(favoriteCollectionView)
        
        NSLayoutConstraint.activate([
            favoriteCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoriteCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchFavoriteEvents() {
        guard SessionManager.shared.userId != nil else {
            print("Kullanıcı ID bulunamadı")
            return
        }
        
        let urlString = "http://localhost:8080/favori/getAll"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Ağ Hatası: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Veri alınamadı")
                return
            }
            do {
                let favorites = try JSONDecoder().decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.favoriteEvent = favorites
                    self.favoriteCollectionView.reloadData()
                }
            } catch {
                print("JSON Çözümleme Hatası: \(error.localizedDescription)")
            }
        }.resume()
    }

    func removeFromFavorites(event: Event) {
        let urlString = "http://localhost:8080/favori/favorites"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["eventID": event.eventID ?? ""]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Favoriden çıkarma hatası: \(error.localizedDescription)")
            } else {
                print("Favoriden çıkarıldı!")
                DispatchQueue.main.async {
                    self.fetchFavoriteEvents()
                }
            }
        }.resume()
    }
}

// MARK: - CollectionView Delegate & DataSource
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteEvent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        let event = favoriteEvent[indexPath.row]
        cell.configure(with: event)
        cell.delegate = self
        return cell
    }
}

// MARK: - Favorite Cell Delegate
extension FavoriteViewController: FavoriteCollectionViewCellDelegate {
    func didTapBuyTicket(event: Event) {
        let ticketVC = TicketsBuyViewController()
        ticketVC.event = event
        navigationController?.pushViewController(ticketVC, animated: true)
    }

    func didTapDelete(event: Event) {
        let alert = UIAlertController(title: "Favoriden Sil", message: "Bu etkinliği favorilerden silmek istiyor musunuz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Evet", style: .destructive) { _ in
            self.removeFromFavorites(event: event)
        })
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }
}
/*
import UIKit

class FavoriteViewController: UIViewController, FavoriteCollectionViewCellDelegate {
    
    var favoriteCollectionView: UICollectionView!
    var favoriteEvent: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Favoriler"
        setupCollectionView()
        fetchFavoriteEvents()
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteEvents()
        favoriteCollectionView.reloadData()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 150)
        layout.minimumLineSpacing = 15
        
        favoriteCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favoriteCollectionView.backgroundColor = .white
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        
        view.addSubview(favoriteCollectionView)
        
        NSLayoutConstraint.activate([
            favoriteCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoriteCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchFavoriteEvents() {
        guard SessionManager.shared.userId != nil else {
            print("Kullanıcı ID bulunamadı")
            return
        }
        
        let urlString = "http://localhost:8080/favori/getAll"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Ağ Hatası: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Veri alınamadı")
                return
            }
            do {
                let favorites = try JSONDecoder().decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.favoriteEvent = favorites
                    self.favoriteCollectionView.reloadData()
                }
            } catch {
                print("JSON Çözümleme Hatası: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func didTapBuyTicket(event: Event) {
        let ticketVC = TicketsBuyViewController()
        ticketVC.event = event
        navigationController?.pushViewController(ticketVC, animated: true)
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteEvent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        let event = favoriteEvent[indexPath.row]
        cell.configure(with: event)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { _, _, completionHandler in
            let event = self.favoriteEvent[indexPath.row]
            
            // Önce veriyi koleksiyondan çıkar
            self.favoriteEvent.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            
            // Sonra backend'e bildir
            self.removeFromFavorites(event: event)
            
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    
    func removeFromFavorites(event: Event) {
        let urlString = "http://localhost:8080/favori/favorites"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Favoriden çıkarma hatası: \(error.localizedDescription)")
            } else {
                print("Favoriden çıkarıldı!")
                DispatchQueue.main.async {
                    self.fetchFavoriteEvents()
                }
            }
        }.resume()
    }
}
*/
