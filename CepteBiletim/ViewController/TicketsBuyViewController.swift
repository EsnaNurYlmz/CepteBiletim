//
//  TicketsBuyViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit

class TicketsBuyViewController: UIViewController {

    // MARK: - UI Elements
    private let eventImageView = UIImageView()
    private let eventNameLabel = UILabel()
    private let artistNameLabel = UILabel()
    private let eventDateLabel = UILabel()
    private let ticketPriceLabel = UILabel()
    private let serviceFeeLabel = UILabel()
    private let totalPriceLabel = UILabel()
    private let ticketCountLabel = UILabel()
    
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let proceedButton = UIButton(type: .system)
    
    // MARK: - Properties
    var event: Event?
    var ticketCount: Int = 1
    var serviceFee: Double = 2.90
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.hidesBottomBarWhenPushed = false

        setupUI()
        
        if let event = event {
            updateUI(with: event)
        }
    }

    // MARK: - UI Setup
    private func setupUI() {
        [eventImageView, eventNameLabel, artistNameLabel, eventDateLabel,
         ticketPriceLabel, serviceFeeLabel, totalPriceLabel,
         ticketCountLabel, minusButton, plusButton, proceedButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true
        
        eventNameLabel.font = .boldSystemFont(ofSize: 20)
        artistNameLabel.font = .systemFont(ofSize: 16)
        eventDateLabel.font = .systemFont(ofSize: 16)
        ticketPriceLabel.font = .systemFont(ofSize: 16)
        serviceFeeLabel.font = .systemFont(ofSize: 16)
        totalPriceLabel.font = .boldSystemFont(ofSize: 18)
        ticketCountLabel.font = .boldSystemFont(ofSize: 18)
        ticketCountLabel.textAlignment = .center

        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        [minusButton, plusButton].forEach {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 24)
            $0.addTarget(self, action: #selector(ticketCountChanged(_:)), for: .touchUpInside)
        }

        proceedButton.setTitle("Şimdi Ödeme Yap", for: .normal)
        proceedButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        proceedButton.backgroundColor = .systemBlue
        proceedButton.setTitleColor(.white, for: .normal)
        proceedButton.layer.cornerRadius = 8
        proceedButton.addTarget(self, action: #selector(proceedToPayment), for: .touchUpInside)
        
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            eventImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 200),
            eventImageView.heightAnchor.constraint(equalToConstant: 200),
            
            eventNameLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 16),
            eventNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            artistNameLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8),
            artistNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            eventDateLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 8),
            eventDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ticketPriceLabel.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: 20),
            ticketPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            serviceFeeLabel.topAnchor.constraint(equalTo: ticketPriceLabel.bottomAnchor, constant: 10),
            serviceFeeLabel.leadingAnchor.constraint(equalTo: ticketPriceLabel.leadingAnchor),
            
            totalPriceLabel.topAnchor.constraint(equalTo: serviceFeeLabel.bottomAnchor, constant: 10),
            totalPriceLabel.leadingAnchor.constraint(equalTo: ticketPriceLabel.leadingAnchor),
            
            minusButton.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 20),
            minusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            minusButton.widthAnchor.constraint(equalToConstant: 40),
            minusButton.heightAnchor.constraint(equalToConstant: 40),
            
            ticketCountLabel.centerYAnchor.constraint(equalTo: minusButton.centerYAnchor),
            ticketCountLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 10),
            ticketCountLabel.widthAnchor.constraint(equalToConstant: 40),
            
            plusButton.centerYAnchor.constraint(equalTo: minusButton.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: ticketCountLabel.trailingAnchor, constant: 10),
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            plusButton.heightAnchor.constraint(equalToConstant: 40),
            
            proceedButton.topAnchor.constraint(equalTo: minusButton.bottomAnchor, constant: 30),
            proceedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            proceedButton.widthAnchor.constraint(equalToConstant: 200),
            proceedButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    // MARK: - UI Update
    private func updateUI(with event: Event) {
        eventNameLabel.text = event.eventName
        eventDateLabel.text = event.eventDate
        artistNameLabel.text = event.artistName
        serviceFeeLabel.text = String(format: "Hizmet Bedeli: %.2f TL", serviceFee)
        
        if let priceString = event.eventPrice, let price = Double(priceString) {
            ticketPriceLabel.text = String(format: "Bilet Fiyatı: %.2f TL", price)
            updateTotalPrice()
        }

        if let imageUrl = event.eventImage, let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.eventImageView.image = image
                    }
                }
            }
        }
    }

    private func updateTotalPrice() {
        if let priceString = event?.eventPrice,
           let price = Double(priceString) {
            let total = Double(ticketCount) * price + serviceFee
            totalPriceLabel.text = String(format: "Toplam: %.2f TL", total)
            ticketCountLabel.text = "\(ticketCount)"
        }
    }

    // MARK: - Actions
    @objc private func ticketCountChanged(_ sender: UIButton) {
        if sender == plusButton {
            ticketCount += 1
        } else if sender == minusButton, ticketCount > 1 {
            ticketCount -= 1
        }
        updateTotalPrice()
    }

    @objc private func proceedToPayment() {
        let paymentVC = PaymentViewController()
        let totalPriceText = totalPriceLabel.text?.replacingOccurrences(of: "Toplam: ", with: "").replacingOccurrences(of: " TL", with: "") ?? "0"
        let totalPriceDouble = Double(totalPriceText) ?? 0.0
        paymentVC.totalAmount = totalPriceDouble
        paymentVC.purchasedEvent = event
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}
