//
//  TicketsViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit

class TicketsViewController: UIViewController {

    var collectionView: UICollectionView!
    var purchasedTickets: [Event] = []
    var userID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        fetchPurchasedTickets()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width - 20, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TicketsCollectionViewCell.self, forCellWithReuseIdentifier: "TicketsCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchPurchasedTickets() {
        guard let userID = userID else { return }
        guard let url = URL(string: "https://api.example.com/getTickets?userId=\(userID)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            if let tickets = try? JSONDecoder().decode([Event].self, from: data) {
                DispatchQueue.main.async {
                    self.purchasedTickets = tickets
                    self.collectionView.reloadData()
                }
            }
        }.resume()
    }
}

extension TicketsViewController: UICollectionViewDelegate, UICollectionViewDataSource, TicketsCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purchasedTickets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketsCell", for: indexPath) as! TicketsCollectionViewCell
        let ticket = purchasedTickets[indexPath.item]
        cell.configure(with: ticket)
        cell.delegate = self
        return cell
    }

    func didTapCommentButton(for event: Event) {
        let reviewVC = ReviewViewController(event: event)
        navigationController?.pushViewController(reviewVC, animated: true)
    }
}
