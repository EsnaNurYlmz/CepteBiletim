//
//  MainTabBarController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()

    }
    private func setupTabBar() {
            let homeVC = UINavigationController(rootViewController: HomePageViewController())
            homeVC.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house"), tag: 0)

            let categoryVC = UINavigationController(rootViewController: CategoryViewController())
            categoryVC.tabBarItem = UITabBarItem(title: "Kategori", image: UIImage(systemName: "line.3.horizontal"), tag: 1)

            let nearbyVC = UINavigationController(rootViewController: LocationViewController())
            nearbyVC.tabBarItem = UITabBarItem(title: "Yakınımda", image: UIImage(systemName: "location"), tag: 2)

            let favoritesVC = UINavigationController(rootViewController: FavoriteViewController())
            favoritesVC.tabBarItem = UITabBarItem(title: "Favoriler", image: UIImage(systemName: "heart"), tag: 3)

            let profileVC = UINavigationController(rootViewController: ProfileViewController())
            profileVC.tabBarItem = UITabBarItem(title: "Hesabım", image: UIImage(systemName: "person.circle"), tag: 4)

            viewControllers = [homeVC, categoryVC, nearbyVC, favoritesVC, profileVC]
            tabBar.tintColor = .systemBlue
            tabBar.backgroundColor = .white
        }
}
