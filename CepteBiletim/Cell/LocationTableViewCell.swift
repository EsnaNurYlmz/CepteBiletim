//
//  LocationTableViewCell.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 4.06.2025.
//

import UIKit

class LocationEventCell: UITableViewCell {

    let eventNameLabel = UILabel()
    let eventLocationLabel = UILabel()
    let eventTypeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        eventNameLabel.font = .boldSystemFont(ofSize: 16)
        eventLocationLabel.font = .systemFont(ofSize: 14)
        eventTypeLabel.font = .italicSystemFont(ofSize: 13)
        eventTypeLabel.textColor = .gray

        [eventNameLabel, eventLocationLabel, eventTypeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            eventLocationLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 4),
            eventLocationLabel.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),

            eventTypeLabel.topAnchor.constraint(equalTo: eventLocationLabel.bottomAnchor, constant: 4),
            eventTypeLabel.leadingAnchor.constraint(equalTo: eventNameLabel.leadingAnchor),
            eventTypeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with event: Event) {
        eventNameLabel.text = event.eventName ?? "Etkinlik Adı"
        eventLocationLabel.text = "📍 \(event.eventLocation ?? "-")"
        eventTypeLabel.text = event.eventType ?? "-"
    }
}
