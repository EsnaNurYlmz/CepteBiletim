//
//  SignUpViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - UI Elements
    let nameTextField = UITextField()
    let surnameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let countryCodeTextField = UITextField()
    let phoneTextField = UITextField()
    let birthDateTextField = UITextField()
    let genderTextField = UITextField()
    let checkBox = UIButton(type: .system)
    let segmentedController = UISegmentedControl(items: ["Giriş Yap", "Üye Ol"])
    let signUpButton = UIButton(type: .system)

    // MARK: - Picker Data
    let countryCode = ["+1 (Kanada)", "+44 (Birleşik Krallık)", "+49 (Almanya)", "+90 (Türkiye)", "+61 (Avustralya)", "+994 (Azerbaycan)", "+32 (Belçika)", "+55 (Brezilya)", "+45 (Danimarka)", "+62 (Endonezya)", "+33 (Fransa)", "+27 (Güney Afrika)", "+91 (Hindistan)", "+34 (İspanya)", "+46 (İsveç)", "+41 (İsviçre)", "+39 (İtalya)", "+57 (Kolombiya)", "+53 (Küba)", "+36 (Macaristan)", "+52 (Meksika)", "+20 (Mısır)", "+47 (Norveç)", "+48 (Polonya)", "+351 (Portekiz)", "+40 (Romanya)", "+66 (Tanzanya)", "+84 (Vietnam)"]
    let genderType = ["Kadın", "Erkek", "Belirsiz"]

    let countryPicker = UIPickerView()
    let genderPicker = UIPickerView()
    let datePicker = UIDatePicker()

    var isTermsAccepted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupPickers()
        setupDatePicker()
        setupTapGesture()
    }

    // MARK: - UI Setup
    func setupUI() {
        let fields = [nameTextField, surnameTextField, emailTextField, passwordTextField, countryCodeTextField, phoneTextField, birthDateTextField, genderTextField]
            let placeholders = ["Ad", "Soyad", "Email", "Şifre", "+90", "Telefon", "Doğum Tarihi", "Cinsiyet"]

            let placeholderColor = UIColor(red: 0.60, green: 0.70, blue: 0.95, alpha: 1.0)

            for (i, field) in fields.enumerated() {
                field.translatesAutoresizingMaskIntoConstraints = false
                field.borderStyle = .roundedRect
                field.layer.cornerRadius = 8
                field.clipsToBounds = true
                field.layer.borderColor = UIColor.gray.cgColor
                field.layer.borderWidth = 1
                if placeholders[i] == "Şifre" {
                        field.isSecureTextEntry = true
                    }
                field.attributedPlaceholder = NSAttributedString(
                    string: placeholders[i],
                    attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
                )
                view.addSubview(field)
            }

        [segmentedController, checkBox, signUpButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        checkBox.setTitle(" KVKK'yi kabul ediyorum", for: .normal)
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.tintColor = .systemBlue
        checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)

        signUpButton.setTitle("KAYIT OL", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = .systemBlue
        signUpButton.layer.cornerRadius = 8
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)

        segmentedController.selectedSegmentIndex = 1
        segmentedController.addTarget(self, action: #selector(segmentedChanged(_:)), for: .valueChanged)

        // Layout Constraints
        NSLayoutConstraint.activate([
            segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        var previous: UIView = segmentedController

        for field in fields {
            NSLayoutConstraint.activate([
                field.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10),
                field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
            previous = field
        }

        NSLayoutConstraint.activate([
            checkBox.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 15),
            checkBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            signUpButton.topAnchor.constraint(equalTo: checkBox.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
            signUpButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Picker Setup
    func setupPickers() {
        countryPicker.delegate = self
        countryPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.dataSource = self

        countryCodeTextField.inputView = countryPicker
        genderTextField.inputView = genderPicker
    }

    func setupDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        birthDateTextField.inputView = datePicker
    }

    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        birthDateTextField.text = formatter.string(from: datePicker.date)
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == countryPicker ? countryCode.count : genderType.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == countryPicker ? countryCode[row] : genderType[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPicker {
            let fullCode = countryCode[row]
            let codeOnly = fullCode.components(separatedBy: " ").first ?? ""
            countryCodeTextField.text = codeOnly
        } else {
            genderTextField.text = genderType[row]
        }
    }

    // MARK: - Actions
    @objc func checkBoxTapped() {
        isTermsAccepted.toggle()
        let imageName = isTermsAccepted ? "checkmark.square.fill" : "square"
        checkBox.setImage(UIImage(systemName: imageName), for: .normal)
        if isTermsAccepted {
                let kvkkVC = PrivacyPolicyViewController()
                if let sheet = kvkkVC.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 20
                }
                present(kvkkVC, animated: true)
            }
    }

    @objc func segmentedChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let loginVC = LoginViewController()
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }

    @objc func signUpTapped() {
        guard  let name = nameTextField.text, !name.isEmpty,
               let surname = surnameTextField.text, !surname.isEmpty,
               let email = emailTextField.text, !email.isEmpty,
               let password = passwordTextField.text, !password.isEmpty,
               let phone = phoneTextField.text, !phone.isEmpty,
               let countryCode = countryCodeTextField.text, !countryCode.isEmpty,
               let gender = genderTextField.text, !gender.isEmpty,
               let birthDate = birthDateTextField.text, !birthDate.isEmpty else{
            showAlert(message: "Lütfen tüm alanları doldurunuz!")
            return
        }
        if !isTermsAccepted {
                    showAlert(message: "Üyeliği tamamlamak için kişisel verilerin korunması şartını kabul etmelisiniz!")
                    return
                }
        let user = User(userID: UUID().uuidString, userName: name, userSurname: surname, userEmail: email, userPassword: password, countryCode: countryCode, userPhoneNumber: phone, userGender: gender, userBirthDate: datePicker.date)
         registerUser(user : user)
    }
    func showAlert(message: String) {
           let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Tamam", style: .default))
           present(alert, animated: true)
       }
    func registerUser (user : User) {
        let url = URL(string: "http://localhost:8080/user/register")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                
                "userName": user.userName ?? "",
                "userSurname": user.userSurname ?? "",
                "userEmail": user.userEmail ?? "",
                "userPassword": "\(user.userPassword ?? "")",
                "countryCode": user.countryCode ?? "",
                "userPhoneNumber": user.userPhoneNumber ?? "",
                "userGender": user.userGender ?? "",
                "userBirthDate": formatDateToString(user.userBirthDate!)
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                print("JSON Serialization Hatası: \(error.localizedDescription)")
                showAlert(message: "Bir hata oluştu. Lütfen tekrar deneyin.")
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.showAlert(message: "Bağlantı hatası: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        self.showAlert(message: "Geçersiz yanıt alındı.")
                        return
                    }
                    
                    if let data = data {
                        do {
                            if httpResponse.statusCode == 200 {
                                self.showAlertWithAction(message: "Üyelik başarılı! Giriş ekranına yönlendiriliyorsunuz.") {
                                    self.navigateToLoginScreen()
                                }
                            } else {
                                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                                print("Response: \(jsonResponse)")
                                self.showAlert(message: "Kayıt başarısız: \(jsonResponse)")
                            }
                        } catch {
                            self.showAlert(message: "Yanıt işlenirken hata oluştu: \(error.localizedDescription)")
                        }
                    } else {
                        self.showAlert(message: "Boş yanıt alındı.")
                    }
                }
            }.resume()
    }
    func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Backend'in beklediği tarih formatı olabilir, gerekirse değiştir
        formatter.locale = Locale(identifier: "en_US_POSIX") // Tarih hatalarını önlemek için
        return formatter.string(from: date)
    }
    func showAlertWithAction(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Başarılı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { _ in
            completion()
        })
        present(alert, animated: true)
    }
    func navigateToLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}
