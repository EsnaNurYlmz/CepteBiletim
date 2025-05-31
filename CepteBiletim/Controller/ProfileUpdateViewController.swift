//
//  ProfileUpdateViewController.swift (Programmatic UI Version)
//  CepteBilet
//
//  Created by Esna nur Yılmaz on 9.12.2024.

import UIKit

class ProfileUpdateViewController: UIViewController {

    // MARK: - UI Elements
    let newNameTextField = UITextField()
    let newSurnameTextField = UITextField()
    let newCountryCodeTextField = UITextField()
    let newPhoneNumberTextField = UITextField()
    let newPasswordTextField = UITextField()
    let profileUpdateButton = UIButton(type: .system)
    let passwordUpdateButton = UIButton(type: .system)

    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Profil Güncelle"
        setupUI()
    }

    // MARK: - UI Setup
    func setupUI() {
        let topFields = [newNameTextField, newSurnameTextField, newCountryCodeTextField, newPhoneNumberTextField]
        let topPlaceholders = ["Yeni Ad", "Yeni Soyad", "Yeni Ülke Kodu", "Yeni Telefon"]
        let placeholderColor = UIColor(red: 0.60, green: 0.70, blue: 0.95, alpha: 1.0)

        for (i, field) in topFields.enumerated() {
            field.translatesAutoresizingMaskIntoConstraints = false
            field.placeholder = topPlaceholders[i]
            field.borderStyle = .roundedRect
            field.layer.cornerRadius = 8
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.gray.cgColor
            field.attributedPlaceholder = NSAttributedString(
                string: topPlaceholders[i],
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
            view.addSubview(field)
        }

        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.placeholder = "Yeni Şifre"
        newPasswordTextField.borderStyle = .roundedRect
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.layer.cornerRadius = 8
        newPasswordTextField.layer.borderWidth = 1

        view.addSubview(newPasswordTextField)

        profileUpdateButton.setTitle("Profili Güncelle", for: .normal)
        profileUpdateButton.backgroundColor = .systemBlue
        profileUpdateButton.setTitleColor(.white, for: .normal)
        profileUpdateButton.layer.cornerRadius = 8
        profileUpdateButton.translatesAutoresizingMaskIntoConstraints = false
        profileUpdateButton.addTarget(self, action: #selector(profileUpdateTapped), for: .touchUpInside)
        view.addSubview(profileUpdateButton)

        passwordUpdateButton.setTitle("Şifreyi Güncelle", for: .normal)
        passwordUpdateButton.backgroundColor = .systemBlue
        passwordUpdateButton.setTitleColor(.white, for: .normal)
        passwordUpdateButton.layer.cornerRadius = 8
        passwordUpdateButton.translatesAutoresizingMaskIntoConstraints = false
        passwordUpdateButton.addTarget(self, action: #selector(passwordUpdateTapped), for: .touchUpInside)
        view.addSubview(passwordUpdateButton)

        NSLayoutConstraint.activate([
            newNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            newNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            newSurnameTextField.topAnchor.constraint(equalTo: newNameTextField.bottomAnchor, constant: 15),
            newSurnameTextField.leadingAnchor.constraint(equalTo: newNameTextField.leadingAnchor),
            newSurnameTextField.trailingAnchor.constraint(equalTo: newNameTextField.trailingAnchor),

            newCountryCodeTextField.topAnchor.constraint(equalTo: newSurnameTextField.bottomAnchor, constant: 15),
            newCountryCodeTextField.leadingAnchor.constraint(equalTo: newNameTextField.leadingAnchor),
            newCountryCodeTextField.trailingAnchor.constraint(equalTo: newNameTextField.trailingAnchor),

            newPhoneNumberTextField.topAnchor.constraint(equalTo: newCountryCodeTextField.bottomAnchor, constant: 15),
            newPhoneNumberTextField.leadingAnchor.constraint(equalTo: newNameTextField.leadingAnchor),
            newPhoneNumberTextField.trailingAnchor.constraint(equalTo: newNameTextField.trailingAnchor),

            profileUpdateButton.topAnchor.constraint(equalTo: newPhoneNumberTextField.bottomAnchor, constant: 20),
            profileUpdateButton.trailingAnchor.constraint(equalTo: newNameTextField.trailingAnchor),
            profileUpdateButton.widthAnchor.constraint(equalToConstant: 160),
            profileUpdateButton.heightAnchor.constraint(equalToConstant: 38),

            newPasswordTextField.topAnchor.constraint(equalTo: profileUpdateButton.bottomAnchor, constant: 30),
            newPasswordTextField.leadingAnchor.constraint(equalTo: newNameTextField.leadingAnchor),
            newPasswordTextField.trailingAnchor.constraint(equalTo: newNameTextField.trailingAnchor),

            passwordUpdateButton.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 20),
            passwordUpdateButton.trailingAnchor.constraint(equalTo: newNameTextField.trailingAnchor),
            passwordUpdateButton.widthAnchor.constraint(equalToConstant: 160),
            passwordUpdateButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }

    // MARK: - Actions
    @objc func profileUpdateTapped() {
        let updateUser = User()
        updateUser.userID = SessionManager.shared.userId
        updateUser.userName = newNameTextField.text?.isEmpty == false ? newNameTextField.text : nil
        updateUser.userSurname = newSurnameTextField.text?.isEmpty == false ? newSurnameTextField.text : nil
        updateUser.countryCode = newCountryCodeTextField.text?.isEmpty == false ? newCountryCodeTextField.text : nil
        updateUser.userPhoneNumber = newPhoneNumberTextField.text?.isEmpty == false ? newPhoneNumberTextField.text : nil
        updateUserProfile(user: updateUser)
    }

    @objc func passwordUpdateTapped() {
        guard let userId = SessionManager.shared.userId, !userId.isEmpty else {
            showAlert(title: "Hata", message: "user ID boş.")
            return
        }
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(title: "Hata", message: "Yeni şifre giriniz.")
            return
        }
        updateUserPassword(userId: userId, newPassword: newPassword)
    }

    // MARK: - Networking
    func updateUserProfile(user: User) {
        let url = URL(string: "http://localhost:8080/user/update")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            showAlert(title: "Hata", message: "Veriler işlenirken bir hata oluştu!")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Bağlantı Hatası", message: error.localizedDescription)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showAlert(title: "Hata", message: "Geçersiz sunucu yanıtı!")
                    return
                }

                if httpResponse.statusCode == 200 {
                    self.showAlert(title: "Başarılı", message: "Profil başarıyla güncellendi!")
                } else {
                    self.showAlert(title: "Hata", message: "Güncelleme başarısız, hata kodu: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }

    func updateUserPassword(userId: String, newPassword: String) {
        let url = URL(string: "http://localhost:8080/user/updatePass")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let passwordUpdateData: [String: Any] = [
            "userID": userId,
            "userPassword": newPassword
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: passwordUpdateData, options: [])
            request.httpBody = jsonData
        } catch {
            showAlert(title: "Hata", message: "Veriler işlenirken bir hata oluştu!")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Bağlantı Hatası", message: error.localizedDescription)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showAlert(title: "Hata", message: "Geçersiz sunucu yanıtı!")
                    return
                }

                if httpResponse.statusCode == 200 {
                    self.showAlert(title: "Başarılı", message: "Şifre başarıyla güncellendi!")
                } else {
                    self.showAlert(title: "Hata", message: "Şifre güncelleme başarısız, hata kodu: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }

    // MARK: - Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

