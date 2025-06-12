//
//  FavoriteCollectionViewCell.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 30.05.2025.
//
import UIKit

protocol FavoriteCollectionViewCellDelegate: AnyObject {
    func didTapBuyTicket(event: Event)
    func didTapDelete(event: Event)
}

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: FavoriteCollectionViewCellDelegate?
    private var currentEvent: Event?

    private let eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .darkGray
        return lbl
    }()
    
    private let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .darkGray
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let buyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Biletini Al", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.layer.cornerRadius = 6
        return btn
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .systemRed
        btn.layer.cornerRadius = 6
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        contentView.addSubview(eventImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(buyButton)
        contentView.addSubview(deleteButton)
        
        buyButton.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with event: Event) {
        currentEvent = event
        titleLabel.text = event.eventName
        dateLabel.text = event.eventDate
        locationLabel.text = event.eventLocation

        if let url = URL(string: event.eventImage ?? "") {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.eventImageView.image = image
                    }
                }
            }.resume()
        }
    }

    @objc private func buyTapped() {
        if let event = currentEvent {
            delegate?.didTapBuyTicket(event: event)
        }
    }

    @objc private func deleteTapped() {
        if let event = currentEvent {
            delegate?.didTapDelete(event: event)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            eventImageView.widthAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            buyButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            buyButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: 110),
            buyButton.heightAnchor.constraint(equalToConstant: 30),

            deleteButton.centerYAnchor.constraint(equalTo: buyButton.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: buyButton.trailingAnchor, constant: 12),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

