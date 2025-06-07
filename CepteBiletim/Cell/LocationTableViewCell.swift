//
//  LocationTableViewCell.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 4.06.2025.
//

import UIKit
import CoreLocation

class LocationTableViewCell: UITableViewCell {
    
    let eventImageView = UIImageView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let distanceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        distanceLabel.font = UIFont.systemFont(ofSize: 14)
        distanceLabel.textColor = .gray
        
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true
        
        contentView.addSubview(eventImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(distanceLabel)
        
        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            eventImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 80),
            eventImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            distanceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            distanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with event: Event, userLocation: CLLocation?) {
        nameLabel.text = event.eventName
        dateLabel.text = event.eventDate
        
        if let address = event.eventLocation, let userLoc = userLocation {
            CLGeocoder().geocodeAddressString(address) { placemarks, _ in
                if let location = placemarks?.first?.location {
                    let distanceInMeters = userLoc.distance(from: location)
                    let distanceInKm = distanceInMeters / 1000
                    DispatchQueue.main.async {
                        self.distanceLabel.text = String(format: "%.1f km uzaklıkta", distanceInKm)
                    }
                }
            }
        }
        
        if let urlString = event.eventImage, let url = URL(string: urlString) {
            // Görsel yüklemek için basit URLSession
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.eventImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
