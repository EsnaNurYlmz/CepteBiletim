import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Logo") // Assets'te olan görsel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Şifre"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let segmentedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Giriş Yap", "Üye Ol"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Giriş Yap", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(loginTapped), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Şifreni Unuttum", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        styleTextFields()
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(segmentedController)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)
        
        segmentedController.addTarget(self, action: #selector(segmentedControllerChanged), for: .valueChanged)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            segmentedController.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            segmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func styleTextFields() {
        let textFields = [emailTextField, passwordTextField]
        let placeholderColor = UIColor(red: 0.60, green: 0.70, blue: 0.95, alpha: 1.0)

        for textField in textFields {
            textField.layer.cornerRadius = 10
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.clipsToBounds = true
            
            if let placeholder = textField.placeholder {
                textField.attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
                )
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func loginTapped() {
        guard let email = emailTextField.text , !email.isEmpty,
              let password = passwordTextField.text , !password.isEmpty else {
            showAlert(message: "Lütfen email ve şifrenizi giriniz!")
            return
        }
        loginUser(email: email, password: password)
    }
    
    @objc func forgotPasswordTapped() {
        let profileUpdateVC = ProfileUpdateViewController()
        navigationController?.pushViewController(profileUpdateVC, animated: true)
    }
    
    @objc func segmentedControllerChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            let signUpVC = SignUpViewController()
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }

    func navigateToHomeScreen() {
        let tabBarVC = MainTabBarController() 
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true, completion: nil)
    }
    
    // MARK: - Alert Helpers
    
    func showAlert(message : String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    func showAlertWithAction(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { _ in
            completion()
        })
        present(alert, animated: true)
    }
    
    // MARK: - Web Servis
    
    func loginUser(email: String , password: String) {
        let url  = URL(string: "http://localhost:8080/user/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "userEmail": email,
            "userPassword": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            showAlert(message: "JSON oluşturulurken hata oluştu.")
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

                guard let data = data else {
                    self.showAlert(message: "Boş yanıt alındı.")
                    return
                }

                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    if let json = jsonResponse as? [String: Any],
                       let userId = json["userID"] as? String {
                        SessionManager.shared.userId = userId
                        print("User ID: \(userId)")
                    }

                    switch httpResponse.statusCode {
                    case 200:
                        self.showAlertWithAction(message: "Giriş başarılı! Ana sayfaya yönlendiriliyorsunuz.") {
                            self.navigateToHomeScreen()
                        }
                    case 401:
                        self.showAlert(message: "Hatalı şifre! Lütfen tekrar deneyin.")
                    case 404:
                        self.showAlert(message: "Kullanıcı bulunamadı! Lütfen kayıt olun.")
                    default:
                        self.showAlert(message: "Hata: \(jsonResponse)")
                    }
                } catch {
                    self.showAlert(message: "Yanıt işlenirken hata oluştu: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

