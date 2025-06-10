//
//  ProfileViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit

class ProfileViewController: UIViewController {

    let profileCategoryTableView = UITableView()
    var profileCategoryList: [String] {
        if SessionManager.shared.isLoggedIn {
            return ["PROFİL DÜZENLE", "BİLETLERİM", "ÇIKIŞ YAP"]
        } else {
            return ["GİRİŞ YAP"]
        }
    }
   
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Hesabım"
        configureLogoImageView()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileCategoryTableView.reloadData()
    }

    
    func configureLogoImageView(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(profileCategoryTableView)
        profileCategoryTableView.translatesAutoresizingMaskIntoConstraints = false
        profileCategoryTableView.delegate = self
        profileCategoryTableView.dataSource = self
        profileCategoryTableView.register(ProfileCategoryTableViewCell.self, forCellReuseIdentifier: "ProfileCategoryCell")
        
        NSLayoutConstraint.activate([
            profileCategoryTableView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            profileCategoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            profileCategoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            profileCategoryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
        ])
    }
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCategoryCell", for: indexPath) as? ProfileCategoryTableViewCell else {
            return UITableViewCell()
        }
        cell.profileCategoryLabel.text = profileCategoryList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let selectedOption = profileCategoryList[indexPath.row]
        
        if selectedOption == "ÇIKIŞ YAP" {
            SessionManager.shared.clearSession()
            tableView.reloadData()
        } else if selectedOption == "GİRİŞ YAP" {
            let loginVC = LoginViewController()
            navigationController?.pushViewController(loginVC, animated: true)
        } else if selectedOption == "PROFİL DÜZENLE" {
            let profileUpdateVC = ProfileUpdateViewController()
            navigationController?.pushViewController(profileUpdateVC, animated: true)
        } else if selectedOption == "BİLETLERİM" {
            let ticketsVC = TicketsViewController()
            navigationController?.pushViewController(ticketsVC, animated: true)
        }
        
    }
}
