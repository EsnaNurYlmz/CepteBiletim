//
//  DetailViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit

class DetailViewController: UIViewController {
    
    let eventImage = UIImageView()
    let eventNameLabel = UILabel()
    let artistNameLabel = UILabel()
    let locationLabel = UILabel()
    let eventDetailTextView = UITextView()
    let buyTicketButton = UIButton(type: .system)
    
    var eventID: String?
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        
        if let eventID = eventID {
            fetchEventDetails(eventID: eventID)
        }
        
        checkIfFavorite()
    }
    
    func setupUI() {
        let heartButton = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(favoriteClicked))

        let locationButton = UIBarButtonItem(image: UIImage(systemName: "map"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(locationClicked))

        navigationItem.rightBarButtonItems = [heartButton, locationButton]
        
        [eventImage, eventNameLabel, artistNameLabel, locationLabel, eventDetailTextView, buyTicketButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        eventImage.contentMode = .scaleAspectFill
        eventImage.clipsToBounds = true
        
        eventNameLabel.font = .boldSystemFont(ofSize: 20)
        artistNameLabel.font = .systemFont(ofSize: 18)
        locationLabel.font = .systemFont(ofSize: 16)
        locationLabel.textColor = .darkGray
        
        eventDetailTextView.isEditable = false
        eventDetailTextView.font = .systemFont(ofSize: 16)
        
        buyTicketButton.setTitle("Biletini Al", for: .normal)
        buyTicketButton.setTitleColor(.white, for: .normal)
        buyTicketButton.backgroundColor = .systemBlue
        buyTicketButton.layer.cornerRadius = 8
        buyTicketButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        buyTicketButton.addTarget(self, action: #selector(buyTicketTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            eventImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            eventImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventImage.widthAnchor.constraint(equalToConstant: 250),
            eventImage.heightAnchor.constraint(equalToConstant: 150),
            
            eventNameLabel.topAnchor.constraint(equalTo: eventImage.bottomAnchor, constant: 15),
            eventNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            artistNameLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 10),
            artistNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 10),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            eventDetailTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            eventDetailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventDetailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventDetailTextView.heightAnchor.constraint(equalToConstant: 120),
            
            buyTicketButton.topAnchor.constraint(equalTo: eventDetailTextView.bottomAnchor, constant: 40),
            buyTicketButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            buyTicketButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            buyTicketButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func fetchEventDetails(eventID: String) {
        let urlString = "http://localhost:8080/event/\(eventID)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Boş veri")
                return
            }
            
            do {
                let eventDetails = try JSONDecoder().decode(Event.self, from: data)
                DispatchQueue.main.async {
                    self.event = eventDetails
                    self.updateUI()
                }
            } catch {
                print("JSON Decode hatası: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func updateUI() {
        guard let event = event else { return }
        eventNameLabel.text = event.eventName
        artistNameLabel.text = event.artistName
        locationLabel.text = event.eventLocation
        eventDetailTextView.text = event.eventType // eventDetail yerine tekrar eventType
        
        if let imageUrl = event.eventImage, let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.eventImage.image = image
                    }
                }
            }
        }
    }
    
    func checkIfFavorite() {
        guard let userId = SessionManager.shared.userId,
              let eventId = event?.eventID else { return }
        
        let urlString = "http://localhost:8080/favorites/check?userId=\(userId)&eventId=\(eventId)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let isFavorite = String(data: data, encoding: .utf8) == "true"
            DispatchQueue.main.async {
                let heartImage = isFavorite ? "heart.fill" : "heart"
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: heartImage)
                self.navigationItem.rightBarButtonItem?.tintColor = isFavorite ? .red : .black
            }
        }.resume()
    }
    
    @objc func favoriteClicked() {
        guard let userId = SessionManager.shared.userId,
              let eventId = event?.eventID else {
            print("Kullanıcı ID veya Etkinlik ID eksik")
            return
        }
        
        let urlString = "http://localhost:8080/favorites"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let favoriteData: [String: Any] = [
            "userId": userId,
            "eventId": eventId
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: favoriteData, options: [])
        } catch {
            print("JSON encode hatası: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Favori ekleme hatası: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
                self.navigationItem.rightBarButtonItem?.tintColor = .red
            }
        }.resume()
    }
    
    @objc func locationClicked() {
        guard let address = locationLabel.text else { return }
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?q=\(encodedAddress)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func buyTicketTapped() {
        let ticketVC = TicketsBuyViewController()
        ticketVC.event = self.event
        ticketVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(ticketVC, animated: true)
    }
}

