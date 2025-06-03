//
//  HomePageViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit

class HomePageViewController: UIViewController, UIScrollViewDelegate {

    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📍 İstanbul", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()

    let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tümünü Gör", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return button
    }()

    let bannerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .systemBlue
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()

    let promoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()

    var bannerTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        seeAllButton.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)

        setupScrollView()
        setupViews()
        setupConstraints()
        startBannerTimer()
        loadPromos()
    }

    func setupViews() {
        view.addSubview(locationButton)
        view.addSubview(seeAllButton)
        view.addSubview(bannerScrollView)
        view.addSubview(pageControl)
        view.addSubview(promoStackView)
    }

    func setupScrollView() {
        bannerScrollView.delegate = self
        let images = ["banner1", "banner2", "banner4", "banner5", "banner6", "banner7"]
        for (index, name) in images.enumerated() {
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: CGFloat(index) * view.frame.width, y: 0,
                                     width: view.frame.width, height: 180)
            bannerScrollView.addSubview(imageView)
        }
        bannerScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(images.count), height: 180)
        pageControl.numberOfPages = images.count
    }

    func setupConstraints() {
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        bannerScrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        promoStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            seeAllButton.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            bannerScrollView.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 12),
            bannerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerScrollView.heightAnchor.constraint(equalToConstant: 180),

            pageControl.topAnchor.constraint(equalTo: bannerScrollView.bottomAnchor, constant: 4),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            promoStackView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
            promoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            promoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            promoStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    func startBannerTimer() {
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let nextPage = (self.pageControl.currentPage + 1) % self.pageControl.numberOfPages
            let offset = CGFloat(nextPage) * self.view.frame.width
            self.bannerScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            self.pageControl.currentPage = nextPage
        }
    }

    func loadPromos() {
        let promos = [
            ("Yaz Festivali Başladı!", "Yüzlerce etkinlikte %20 indirim fırsatını kaçırma."),
            ("Biletini Hemen Al!", "Popüler konserler hızla tükeniyor."),
            ("Ön Satış Avantajı!", "Tiyatro biletlerinde %30'a varan indirim.")
        ]

        for promo in promos {
            let card = PromoCardView(title: promo.0, subtitle: promo.1)
            promoStackView.addArrangedSubview(card)
        }
    }

    @objc func seeAllButtonTapped() {
        let categoryVC = CategoryViewController()
        navigationController?.pushViewController(categoryVC, animated: true)
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerScrollView {
            let index = Int(round(scrollView.contentOffset.x / view.frame.width))
            pageControl.currentPage = index
        }
    }
}

// MARK: - PromoCardView
class PromoCardView: UIView {
    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        backgroundColor = .systemBlue
        layer.cornerRadius = 12
        layer.masksToBounds = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 6

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
import UIKit

class HomePageViewController: UIViewController {

    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📍 İstanbul", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()

    let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Bugün İçin Öneriler"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tümünü Gör", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()

    lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [todayLabel, seeAllButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    let bannerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .systemBlue
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()

    let promoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()

    var bannerTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupScrollView()
        setupViews()
        setupConstraints()
        startBannerTimer()
        loadPromos()
    }

    func setupViews() {
        view.addSubview(locationButton)
        view.addSubview(headerStack)
        view.addSubview(bannerScrollView)
        view.addSubview(pageControl)
        view.addSubview(promoStackView)
    }

    func setupScrollView() {
        bannerScrollView.delegate = self
        let images = ["banner1", "banner2", "banner4", "banner5", "banner6", "banner7"]
        for (index, name) in images.enumerated() {
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: CGFloat(index) * view.frame.width, y: 0,
                                     width: view.frame.width, height: 180)
            bannerScrollView.addSubview(imageView)
        }
        bannerScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(images.count), height: 180)
    }

    func setupConstraints() {
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        bannerScrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        promoStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            headerStack.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 12),
            headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            bannerScrollView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 12),
            bannerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerScrollView.heightAnchor.constraint(equalToConstant: 180),

            pageControl.topAnchor.constraint(equalTo: bannerScrollView.bottomAnchor, constant: 4),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            promoStackView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
            promoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            promoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            promoStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    func startBannerTimer() {
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let nextPage = (self.pageControl.currentPage + 1) % self.pageControl.numberOfPages
            let offset = CGFloat(nextPage) * self.view.frame.width
            self.bannerScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            self.pageControl.currentPage = nextPage
        }
    }

    func loadPromos() {
        let promos = [
            ("Yaz Festivali Başladı!", "Yüzlerce etkinlikte %20 indirim fırsatını kaçırma."),
            ("Biletini Hemen Al!", "Popüler konserler hızla tükeniyor."),
            ("Ön Satış Avantajı!", "Tiyatro biletlerinde %30'a varan indirim.")
        ]

        for promo in promos {
            let card = PromoCardView(title: promo.0, subtitle: promo.1)
            promoStackView.addArrangedSubview(card)
        }
    }
    
}

// MARK: - ScrollView Delegate
extension HomePageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerScrollView {
            let index = Int(round(scrollView.contentOffset.x / view.frame.width))
            pageControl.currentPage = index
        }
    }
}

// MARK: - PromoCardView
class PromoCardView: UIView {
    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        backgroundColor = .systemBlue
        layer.cornerRadius = 12
        layer.masksToBounds = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 6

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}*/
