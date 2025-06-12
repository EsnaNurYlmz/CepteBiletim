//
//  PaymentViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//
// PaymentViewController.swift

import UIKit

class PaymentViewController: UIViewController {
    
    // MARK: - UI Elements
    let cardNumberField = UITextField()
    let expiryMonthField = UITextField()
    let expiryYearField = UITextField()
    let cvvField = UITextField()
    let invoiceSwitch = UISwitch()
    let invoiceLabel = UILabel()
    let infoSwitch = UISwitch()
    let infoLabel = UILabel()
    let totalLabel = UILabel()
    let payButton = UIButton(type: .system)
    
    // MARK: - Data
    var totalAmount: Double = 0.0
    var userID: String? // Kullanıcı ID
    var purchasedEvent: Event? // Satın alınan etkinlik

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Ödeme"
        self.hidesBottomBarWhenPushed = false

        setupUI()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        setupTextField(cardNumberField, placeholder: "Kart Numarası")
        setupTextField(expiryMonthField, placeholder: "Ay (MM)")
        setupTextField(expiryYearField, placeholder: "Yıl (YY)")
        setupTextField(cvvField, placeholder: "CVV")
        cvvField.isSecureTextEntry = true
        
        invoiceLabel.text = "Kurumsal Fatura İstiyorum"
        infoLabel.text = "Ön Bilgilendirme Onaylıyorum *"
        totalLabel.text = String(format: "Toplam Tutar: %.2f TL", totalAmount)
        totalLabel.font = .boldSystemFont(ofSize: 18)
        
        payButton.setTitle("Ödemeyi Tamamla", for: .normal)
        payButton.backgroundColor = .systemBlue
        payButton.setTitleColor(.white, for: .normal)
        payButton.layer.cornerRadius = 10
        payButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        payButton.addTarget(self, action: #selector(completePayment), for: .touchUpInside)
        
        infoSwitch.addTarget(self, action: #selector(togglePayButton), for: .valueChanged)
        payButton.isEnabled = false
        payButton.alpha = 0.5

        [cardNumberField, expiryMonthField, expiryYearField, cvvField,
         invoiceSwitch, invoiceLabel,
         infoSwitch, infoLabel,
         totalLabel, payButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        setupConstraints()
    }
    
    func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardNumberField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cardNumberField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardNumberField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardNumberField.heightAnchor.constraint(equalToConstant: 44),
            
            expiryMonthField.topAnchor.constraint(equalTo: cardNumberField.bottomAnchor, constant: 15),
            expiryMonthField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expiryMonthField.widthAnchor.constraint(equalToConstant: 100),
            expiryMonthField.heightAnchor.constraint(equalToConstant: 44),
            
            expiryYearField.topAnchor.constraint(equalTo: expiryMonthField.topAnchor),
            expiryYearField.leadingAnchor.constraint(equalTo: expiryMonthField.trailingAnchor, constant: 10),
            expiryYearField.widthAnchor.constraint(equalToConstant: 100),
            expiryYearField.heightAnchor.constraint(equalToConstant: 44),
            
            cvvField.topAnchor.constraint(equalTo: expiryMonthField.bottomAnchor, constant: 15),
            cvvField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cvvField.widthAnchor.constraint(equalToConstant: 100),
            cvvField.heightAnchor.constraint(equalToConstant: 44),
            
            invoiceSwitch.topAnchor.constraint(equalTo: cvvField.bottomAnchor, constant: 30),
            invoiceSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            invoiceLabel.centerYAnchor.constraint(equalTo: invoiceSwitch.centerYAnchor),
            invoiceLabel.leadingAnchor.constraint(equalTo: invoiceSwitch.trailingAnchor, constant: 10),
            
            infoSwitch.topAnchor.constraint(equalTo: invoiceSwitch.bottomAnchor, constant: 20),
            infoSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            infoLabel.centerYAnchor.constraint(equalTo: infoSwitch.centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: infoSwitch.trailingAnchor, constant: 10),
            
            totalLabel.topAnchor.constraint(equalTo: infoSwitch.bottomAnchor, constant: 30),
            totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            payButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 30),
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.widthAnchor.constraint(equalToConstant: 200),
            payButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func togglePayButton() {
        let isEnabled = infoSwitch.isOn
        payButton.isEnabled = isEnabled
        payButton.alpha = isEnabled ? 1.0 : 0.5
    }
    @objc func completePayment() {
        guard infoSwitch.isOn else {
            let alert = UIAlertController(title: "Uyarı", message: "Ön bilgilendirme onayı zorunludur.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true)
            return
        }


        let urlString = "http://localhost:8080/ticket/addTicket"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let ticketData: [String: Any] = [
            "eventID": purchasedEvent?.eventID ?? ""
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: ticketData, options: [])
    

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error == nil {
                    let alert = UIAlertController(title: "Başarılı", message: "Ödeme işlemi tamamlandı!", preferredStyle: .alert)
                    self.present(alert, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        alert.dismiss(animated: true) {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Hata", message: "Ödeme başarılı ama bilet kaydedilemedi.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }.resume()
    }

  /*  @objc func completePayment() {
        guard infoSwitch.isOn else {
            let alert = UIAlertController(title: "Uyarı", message: "Ön bilgilendirme onayı zorunludur.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true)
            return
        }

        // Etkinliği satın alma işlemi
        guard let event = purchasedEvent,
              let userID = userID,
              let url = URL(string: "https://api.example.com/addTicket") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let ticketData: [String: Any] = [
            "userId": userID,
            "eventId": event.eventID ?? "",
            "eventName": event.eventName ?? "",
            "eventDate": event.eventDate ?? "",
            "eventLocation": event.eventLocation ?? "",
            "eventType": event.eventType ?? "",
            "eventImage": event.eventImage ?? "",
            "eventPrice": event.eventPrice ?? "",
            "artistName": event.artistName ?? "",
            "eventCategory": event.eventCategory ?? ""
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: ticketData, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error == nil {
                    let alert = UIAlertController(title: "Başarılı", message: "Ödeme işlemi tamamlandı!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Biletlerim", style: .default, handler: { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Hata", message: "Ödeme başarılı ama bilet kaydedilemedi.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }.resume()
    }*/
}
