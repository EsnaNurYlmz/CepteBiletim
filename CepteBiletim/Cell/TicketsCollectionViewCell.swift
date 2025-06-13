//
//  TicketsCollectionViewCell.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 30.05.2025.

import UIKit

protocol TicketsCollectionViewCellDelegate: AnyObject {
    func didTapCommentButton(for event: Event)
}

class TicketsCollectionViewCell: UICollectionViewCell {

    weak var delegate: TicketsCollectionViewCellDelegate?
    private var event: Event?

    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 13)
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingBadge: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemYellow
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📝 Yorum", for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor

        contentView.addSubview(eventImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(commentButton)
        contentView.addSubview(commentLabel)
        contentView.addSubview(ratingBadge)

        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            eventImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 80),
            eventImageView.heightAnchor.constraint(equalToConstant: 80),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            commentButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            commentButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            commentButton.widthAnchor.constraint(equalToConstant: 100),
            commentButton.heightAnchor.constraint(equalToConstant: 30),

            ratingBadge.centerYAnchor.constraint(equalTo: commentButton.centerYAnchor),
            ratingBadge.trailingAnchor.constraint(equalTo: commentButton.leadingAnchor, constant: -8),
            ratingBadge.widthAnchor.constraint(equalToConstant: 40),
            ratingBadge.heightAnchor.constraint(equalToConstant: 24),

            commentLabel.topAnchor.constraint(equalTo: commentButton.bottomAnchor, constant: 6),
            commentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
    }

    func configure(with event: Event) {
        self.event = event
        nameLabel.text = event.eventName
        dateLabel.text = event.eventDate
        locationLabel.text = event.eventLocation

        // Görsel yükleme
        if let imageUrl = URL(string: event.eventImage ?? "") {
            loadImage(for: imageUrl)
        }

        // Yorum ve puanı göster
        if let eventId = event.eventID,
           let review = SessionManager.shared.reviews[eventId] {
            commentLabel.text = "\"\(review.comment)\""
            ratingBadge.text = "\(review.rating)★"
            commentLabel.isHidden = false
            ratingBadge.isHidden = false
        } else {
            commentLabel.isHidden = true
            ratingBadge.isHidden = true
        }
    }

    private func loadImage(for url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.eventImageView.image = image
                }
            }
        }.resume()
    }

    @objc private func commentButtonTapped() {
        guard let event = event else { return }
        delegate?.didTapCommentButton(for: event)
    }
}




/*
import UIKit

protocol TicketsCollectionViewCellDelegate: AnyObject {
    func didTapCommentButton(for event: Event)
}

class TicketsCollectionViewCell: UICollectionViewCell {

    weak var delegate: TicketsCollectionViewCellDelegate?
    private var event: Event?

    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📝 Yorum", for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor

        contentView.addSubview(eventImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(commentButton)

        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            eventImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 80),
            eventImageView.heightAnchor.constraint(equalToConstant: 80),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            commentButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            commentButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            commentButton.widthAnchor.constraint(equalToConstant: 100),
            commentButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
    }

    func configure(with event: Event) {
        self.event = event
        nameLabel.text = event.eventName
        dateLabel.text = event.eventDate
        locationLabel.text = event.eventLocation

        if let imageUrl = URL(string: event.eventImage ?? "") {
            loadImage(for: imageUrl)
        }
    }

    private func loadImage(for url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.eventImageView.image = image
                }
            }
        }.resume()
    }

    @objc private func commentButtonTapped() {
        guard let event = event else { return }
        delegate?.didTapCommentButton(for: event)
    }
}
*/
