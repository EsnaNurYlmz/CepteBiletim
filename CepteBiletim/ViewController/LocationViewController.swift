//
//  LocationViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//
import UIKit

class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let mekanTextField = UITextField()
    private let araButton = UIButton(type: .system)
    private let tableView = UITableView()
    private let bosLabel = UILabel()

    var allEvents: [Event] = []
    var filteredEvents: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Yakındaki Etkinlikler"

        setupUI()
        fetchEventsFromWebService()
    }

    private func setupUI() {
        // Mekan TextField
        mekanTextField.placeholder = "Mekan adı yazınız"
        mekanTextField.borderStyle = .roundedRect
        mekanTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mekanTextField)

        // Ara Butonu
        araButton.setTitle("Etkinlikleri Getir", for: .normal)
        araButton.addTarget(self, action: #selector(araButonunaTiklandi), for: .touchUpInside)
        araButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(araButton)

        // Boş Label
        bosLabel.text = "Bu mekana ait etkinlik bulunamadı."
        bosLabel.textAlignment = .center
        bosLabel.textColor = .gray
        bosLabel.isHidden = true
        bosLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bosLabel)

        // TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LocationEventCell.self, forCellReuseIdentifier: "LocationEventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            mekanTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mekanTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mekanTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mekanTextField.heightAnchor.constraint(equalToConstant: 40),

            araButton.topAnchor.constraint(equalTo: mekanTextField.bottomAnchor, constant: 12),
            araButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            bosLabel.topAnchor.constraint(equalTo: araButton.bottomAnchor, constant: 20),
            bosLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bosLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: araButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchEventsFromWebService() {
        guard let url = URL(string: "http://localhost:8080/event/getAll") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                let events = try JSONDecoder().decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.allEvents = events
                }
            } catch {
                print("Decode hatası: \(error.localizedDescription)")
            }
        }.resume()
    }

    @objc private func araButonunaTiklandi() {
        guard let mekan = mekanTextField.text?.lowercased(), !mekan.isEmpty else { return }

        filteredEvents = allEvents.filter {
            ($0.eventLocation ?? "").lowercased().contains(mekan)
        }

        if filteredEvents.isEmpty {
            bosLabel.isHidden = false
        } else {
            bosLabel.isHidden = true
        }

        tableView.reloadData()
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationEventCell", for: indexPath) as? LocationEventCell else {
            return UITableViewCell()
        }
        let event = filteredEvents[indexPath.row]
        cell.configure(with: event)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = filteredEvents[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.eventID = selectedEvent.eventID
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
