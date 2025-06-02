//
//  ReviewViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 30.05.2025.
//

import UIKit

class ReviewViewController: UIViewController {

    private var event: Event

        init(event: Event) {
            self.event = event
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            // örnek:
            print("Etkinlik adı: \(event.eventName)")
        }
}
