//
//  NearbyTableViewCell.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 10.06.2025.
//

import UIKit

class NearbyEventCell: UITableViewCell {

    static let identifier = "NearbyEventCell"

    let eventImageView = UIImageView()
    let eventNameLabel = UILabel()
    let locationLabel = UILabel()
    let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true
        eventImageView.layer.cornerRadius = 8

        eventNameLabel.font = .boldSystemFont(ofSize: 16)
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .darkGray
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .systemBlue

        contentView.addSubview(eventImageView)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            eventImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 80),
            eventImageView.heightAnchor.constraint(equalToConstant: 80),

            eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            eventNameLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 12),
            eventNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            locationLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 6),
            locationLabel.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: eventNameLabel.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: eventNameLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with event: Event) {
        eventNameLabel.text = event.eventName
        locationLabel.text = event.eventLocation
        dateLabel.text = event.eventDate

        if let imageUrlString = event.eventImage,
           let url = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.eventImageView.image = image
                    }
                }
            }
        } else {
            self.eventImageView.image = UIImage(systemName: "photo")
        }
    }
}

