//
//  CategoryDetailViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit

class CategoryDetailViewController: UIViewController {

    var recommendedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Önerilenler"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    var recommendedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    var eventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    var events: [Event] = []
    var recommendedEvents: [Event] = []
    var selectedCategory: Category?
    
    let currentUserID = "12345" // Şimdilik sabit, login sonrası gönderirsin

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()

        recommendedCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self

        recommendedCollectionView.register(CategoryDetailRecommendedCollectionViewCell.self, forCellWithReuseIdentifier: "RecommendedCell")
        eventCollectionView.register(CategoryDetailCollectionViewCell.self, forCellWithReuseIdentifier: "categoryDetailCell")

        fetchEvent()
        fetchRecommendedEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEvent()
        fetchRecommendedEvents()
    }

    func setupViews() {
        view.addSubview(recommendedLabel)
        view.addSubview(recommendedCollectionView)
        view.addSubview(eventCollectionView)

        NSLayoutConstraint.activate([
            recommendedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            recommendedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            recommendedCollectionView.topAnchor.constraint(equalTo: recommendedLabel.bottomAnchor, constant: 8),
            recommendedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recommendedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recommendedCollectionView.heightAnchor.constraint(equalToConstant: 160),

            eventCollectionView.topAnchor.constraint(equalTo: recommendedCollectionView.bottomAnchor, constant: 8),
            eventCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchEvent() {
        guard let category = selectedCategory?.categoryID else { return }
        let urlString = "http://localhost:8080/event/category/\(category)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Event Fetch Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data for events")
                return
            }
            do {
                let fetchedEvents = try JSONDecoder().decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.events = fetchedEvents
                    self.eventCollectionView.reloadData()
                }
            } catch {
                print("Event JSON Decode Error: \(error.localizedDescription)")
            }
        }.resume()
    }

    func fetchRecommendedEvents() {
        let urlString = "http://localhost:8080/event/recommended"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Recommended Fetch Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data for recommended events")
                return
            }
            do {
                let fetchedRecommendedEvents = try JSONDecoder().decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.recommendedEvents = fetchedRecommendedEvents
                    self.recommendedCollectionView.reloadData()
                }
            } catch {
                print("Recommended JSON Decode Error: \(error.localizedDescription)")
            }
        }.resume()
    }

}

// MARK: - CollectionView Delegate & Datasource
extension CategoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recommendedCollectionView {
            return recommendedEvents.count
        } else {
            return events.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recommendedCollectionView {
            let event = recommendedEvents[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCell", for: indexPath) as! CategoryDetailRecommendedCollectionViewCell
            cell.configure(with: event)
            return cell
        } else {
            let event = events[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryDetailCell", for: indexPath) as! CategoryDetailCollectionViewCell
            cell.configure(with: event)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent: Event
        if collectionView == recommendedCollectionView {
            selectedEvent = recommendedEvents[indexPath.row]
        } else {
            selectedEvent = events[indexPath.row]
        }
        
        let detailVC = DetailViewController()
        detailVC.eventID = selectedEvent.eventID
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recommendedCollectionView {
            return CGSize(width: 120, height: 150)
        } else {
            return CGSize(width: collectionView.frame.width - 32, height: 200)
        }
    }
}

/*
import UIKit

class CategoryDetailViewController: UIViewController {

    var recommendedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Önerilenler"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    var recommendedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    var eventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    var events: [Event] = []
    var selectedCategory: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()

        recommendedCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self

        recommendedCollectionView.register(CategoryDetailRecommendedCollectionViewCell.self, forCellWithReuseIdentifier: "RecommendedCell")
        eventCollectionView.register(CategoryDetailCollectionViewCell.self, forCellWithReuseIdentifier: "categoryDetailCell")

        fetchEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchEvent()
    }
    

    func setupViews() {
        view.addSubview(recommendedLabel)
        view.addSubview(recommendedCollectionView)
        view.addSubview(eventCollectionView)

        NSLayoutConstraint.activate([
            recommendedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            recommendedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            recommendedCollectionView.topAnchor.constraint(equalTo: recommendedLabel.bottomAnchor, constant: 8),
            recommendedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recommendedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recommendedCollectionView.heightAnchor.constraint(equalToConstant: 160),

            eventCollectionView.topAnchor.constraint(equalTo: recommendedCollectionView.bottomAnchor, constant: 8),
            eventCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchEvent() {
        guard let category = selectedCategory?.categoryID else { return }
        let urlString = "http://localhost:8080/event/category/\(category)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Error: No data received")
                return
            }
            do {
                let fetchedEvents = try JSONDecoder().decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.events = fetchedEvents
                    self.eventCollectionView.reloadData()
                    self.recommendedCollectionView.reloadData()
                }
            } catch {
                print("JSON Decode Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

// MARK: - CollectionView Delegeleri ve Datasource
extension CategoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.row]

        if collectionView == recommendedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCell", for: indexPath) as! CategoryDetailRecommendedCollectionViewCell
            cell.configure(with: event)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryDetailCell", for: indexPath) as! CategoryDetailCollectionViewCell
            cell.configure(with: event)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent = events[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.eventID = selectedEvent.eventID
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recommendedCollectionView {
            return CGSize(width: 120, height: 150)
        } else {
            return CGSize(width: collectionView.frame.width - 32, height: 200)
        }
    }
}*/
/*
import UIKit

class CategoryDetailViewController: UIViewController {

    var recommendedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Önerilenler"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    var recommendedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    var eventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    var events: [Event] = []
    var selectedCategory: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()

        recommendedCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self

        recommendedCollectionView.register(CategoryDetailRecommendedCollectionViewCell.self, forCellWithReuseIdentifier: "RecommendedCell")
        eventCollectionView.register(CategoryDetailCollectionViewCell.self, forCellWithReuseIdentifier: "categoryDetailCell")

        fetchEvent()
    }

    func setupViews() {
        view.addSubview(recommendedLabel)
        view.addSubview(recommendedCollectionView)
        view.addSubview(eventCollectionView)

        NSLayoutConstraint.activate([
            recommendedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            recommendedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            recommendedCollectionView.topAnchor.constraint(equalTo: recommendedLabel.bottomAnchor, constant: 8),
            recommendedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recommendedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recommendedCollectionView.heightAnchor.constraint(equalToConstant: 160),

            eventCollectionView.topAnchor.constraint(equalTo: recommendedCollectionView.bottomAnchor, constant: 8),
            eventCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchEvent() {
        guard let category = selectedCategory?.categoryID else { return }
        let urlString = "http://localhost:8080/event/category/\(category)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Error: No data received")
                return
            }
            do {
                let fetchedEvents = try JSONDecoder().decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.events = fetchedEvents
                    self.eventCollectionView.reloadData()
                    self.recommendedCollectionView.reloadData()
                }
            } catch {
                print("JSON Decode Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

// MARK: - CollectionView Delegeleri ve Datasource
extension CategoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.row]

        if collectionView == recommendedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCell", for: indexPath) as! CategoryDetailRecommendedCollectionViewCell
            cell.configure(with: event)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryDetailCell", for: indexPath) as! CategoryDetailCollectionViewCell
            cell.configure(with: event)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent = events[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.eventID = selectedEvent.eventID
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recommendedCollectionView {
            return CGSize(width: 120, height: 150)
        } else {
            return CGSize(width: collectionView.frame.width - 32, height: 200)
        }
    }
}*/
