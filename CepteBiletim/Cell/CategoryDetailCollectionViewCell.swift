//
//  CategoryDetailCollectionViewCell.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 30.05.2025.
//
import UIKit

class CategoryDetailCollectionViewCell: UICollectionViewCell {

    let eventImageView = UIImageView()
    let eventNameLabel = UILabel()
    let eventTypeLabel = UILabel()
    let eventDateLabel = UILabel()
    let favoriteButton = UIButton(type: .system)
    let eventVenueLabel = UILabel()

    private var event: Event?

    var isFavorited = false {
        didSet {
            let imageName = isFavorited ? "heart.fill" : "heart"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupFavoriteAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true
        eventImageView.layer.cornerRadius = 8

        eventNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        eventNameLabel.numberOfLines = 2

        eventTypeLabel.font = UIFont.systemFont(ofSize: 14)
        eventTypeLabel.textColor = .darkGray

        eventDateLabel.font = UIFont.systemFont(ofSize: 14)
        eventDateLabel.textColor = .systemBlue

        favoriteButton.tintColor = .systemRed

        eventVenueLabel.font = UIFont.systemFont(ofSize: 13)
        eventVenueLabel.textColor = .gray

        [eventImageView, eventNameLabel, eventTypeLabel, eventDateLabel, favoriteButton, eventVenueLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            // Görsel solda ve büyük
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            eventImageView.bottomAnchor.constraint(equalTo: eventVenueLabel.topAnchor, constant: -8),
            eventImageView.widthAnchor.constraint(equalToConstant: 130),
            eventImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),

            // Etkinlik adı
            eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventNameLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 12),
            eventNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            // Tür
            eventTypeLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 4),
            eventTypeLabel.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),
            eventTypeLabel.trailingAnchor.constraint(equalTo: eventNameLabel.trailingAnchor),

            // Tarih ve favori butonu aynı hizada
            eventDateLabel.topAnchor.constraint(equalTo: eventTypeLabel.bottomAnchor, constant: 4),
            eventDateLabel.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),

            favoriteButton.centerYAnchor.constraint(equalTo: eventDateLabel.centerYAnchor),
            favoriteButton.leadingAnchor.constraint(equalTo: eventDateLabel.trailingAnchor, constant: 8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),

            // Mekan bilgisi en altta ve tam genişlikte
            eventVenueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            eventVenueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            eventVenueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            eventVenueLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    private func setupFavoriteAction() {
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }

    @objc private func favoriteTapped() {
        isFavorited.toggle()
        if let eventID = event?.eventID {
            toggleFavoriteStatus(for: eventID)
        }
    }

    func configure(with event: Event) {
        self.event = event
        eventNameLabel.text = event.eventName
        eventTypeLabel.text = event.eventType
        eventDateLabel.text = event.eventDate
        eventVenueLabel.text = event.eventLocation
        isFavorited = false

        if let imageURL = URL(string: event.eventImage ?? "") {
            loadImage(from: imageURL)
        } else {
            eventImageView.image = UIImage(systemName: "photo")
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.eventImageView.image = img
                }
            }
        }.resume()
    }

    private func toggleFavoriteStatus(for eventID: String) {
        let urlString = "https://api.example.com/favorites"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = isFavorited ? "POST" : "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["event_id": eventID]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Favori isteği hatası: \(error.localizedDescription)")
            } else {
                print(self.isFavorited ? "Favoriye eklendi" : "Favoriden çıkarıldı")
            }
        }.resume()
    }
}

/*import UIKit

class CategoryDetailCollectionViewCell: UICollectionViewCell {

    let eventImageView = UIImageView()
    let eventNameLabel = UILabel()
    let eventVenueLabel = UILabel()
    let eventTypeLabel = UILabel()
    let eventDateLabel = UILabel()
    let favoriteButton = UIButton(type: .system)

    private var event: Event?

    var isFavorited = false {
        didSet {
            let imageName = isFavorited ? "heart.fill" : "heart"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupFavoriteAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.backgroundColor = .white
            contentView.layer.cornerRadius = 12
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowOpacity = 0.1
            contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
            contentView.layer.shadowRadius = 4
            contentView.layer.masksToBounds = false

            eventImageView.contentMode = .scaleAspectFill
            eventImageView.clipsToBounds = true

            eventNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            eventNameLabel.numberOfLines = 2
            eventNameLabel.textColor = .black

            eventVenueLabel.font = UIFont.systemFont(ofSize: 15)
            eventVenueLabel.textColor = .darkGray
            eventVenueLabel.numberOfLines = 1

            eventTypeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            eventTypeLabel.textColor = .systemIndigo

            eventDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            eventDateLabel.textColor = .systemBlue

            favoriteButton.tintColor = .systemRed

            [eventImageView, eventNameLabel, eventVenueLabel, eventTypeLabel, eventDateLabel, favoriteButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview($0)
            }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
               eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
               eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               eventImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               eventImageView.heightAnchor.constraint(equalToConstant: 160),

               eventNameLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 10),
               eventNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
               eventNameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),

               favoriteButton.centerYAnchor.constraint(equalTo: eventNameLabel.centerYAnchor),
               favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
               favoriteButton.widthAnchor.constraint(equalToConstant: 24),
               favoriteButton.heightAnchor.constraint(equalToConstant: 24),

               eventVenueLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 6),
               eventVenueLabel.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),
               eventVenueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

               eventTypeLabel.topAnchor.constraint(equalTo: eventVenueLabel.bottomAnchor, constant: 10),
               eventTypeLabel.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),

               eventDateLabel.centerYAnchor.constraint(equalTo: eventTypeLabel.centerYAnchor),
               eventDateLabel.leadingAnchor.constraint(equalTo: eventTypeLabel.trailingAnchor, constant: 16),
               eventDateLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12),

               eventDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
           ])
    }

    private func setupFavoriteAction() {
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }

    @objc private func favoriteTapped() {
        isFavorited.toggle()
        if let eventID = event?.eventID {
            toggleFavoriteStatus(for: eventID)
        }
    }

    func configure(with event: Event) {
        self.event = event
        eventNameLabel.text = event.eventName
        eventVenueLabel.text = event.eventLocation
        eventTypeLabel.text = event.eventType
        eventDateLabel.text = event.eventDate
        isFavorited = false // varsayılan başlangıç durumu

        if let imageURL = URL(string: event.eventImage ?? "") {
            loadImage(from: imageURL)
        } else {
            eventImageView.image = UIImage(systemName: "photo")
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.eventImageView.image = img
                }
            }
        }.resume()
    }

    private func toggleFavoriteStatus(for eventID: String) {
        let urlString = "https://api.example.com/favorites"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = isFavorited ? "POST" : "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["event_id": eventID]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Favori isteği hatası: \(error.localizedDescription)")
            } else {
                print(self.isFavorited ? "Favoriye eklendi" : "Favoriden çıkarıldı")
            }
        }.resume()
    }
}
*/
