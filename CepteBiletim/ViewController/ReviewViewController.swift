//
//  ReviewViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 9.06.2025.
//

import UIKit

class ReviewViewController: UIViewController {

    // MARK: - UI
    private let titleLabel = UILabel()
    private let commentTextView = UITextView()
    private let ratingSlider = UISlider()
    private let ratingLabel = UILabel()
    private let submitButton = UIButton(type: .system)

    // MARK: - Data
    private let event: Event

    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
        self.title = "Yorum Yap"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    // MARK: - Setup
    func setupUI() {
        titleLabel.text = event.eventName
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center

        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 8
        commentTextView.font = .systemFont(ofSize: 16)

        ratingSlider.minimumValue = 1
        ratingSlider.maximumValue = 5
        ratingSlider.value = 3
        ratingSlider.tintColor = .systemYellow
        ratingSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)

        ratingLabel.text = "Puan: 3"
        ratingLabel.textAlignment = .center

        submitButton.setTitle("Gönder", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

        // Stack View
        let stack = UIStackView(arrangedSubviews: [titleLabel, commentTextView, ratingSlider, ratingLabel, submitButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            commentTextView.heightAnchor.constraint(equalToConstant: 120),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions
    @objc private func sliderValueChanged() {
        let rating = Int(ratingSlider.value.rounded())
        ratingLabel.text = "Puan: \(rating)"
    }

    @objc private func submitTapped() {
        guard let userId = SessionManager.shared.userId else {
            showAlert(title: "Hata", message: "Giriş yapmanız gerekiyor.")
            return
        }

        let comment = commentTextView.text ?? ""
        let rating = Int(ratingSlider.value.rounded())

        let reviewData: [String: Any] = [
            "userId": userId,
            "eventId": event.eventID ?? "",
            "comment": comment,
            "rating": rating
        ]

        guard let url = URL(string: "http://localhost:8080/review/add") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: reviewData)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error == nil {
                    self.showAlert(title: "Teşekkürler", message: "Yorumunuz başarıyla gönderildi.") {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.showAlert(title: "Hata", message: "Yorum gönderilemedi.")
                }
            }
        }.resume()
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Tamam", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }
}


