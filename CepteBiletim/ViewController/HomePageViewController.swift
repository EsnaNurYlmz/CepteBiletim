//
//  HomePageViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//
import UIKit

class HomePageViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - UI Elements

    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Etkinlik, sanatçı veya mekan ara"
        sb.searchBarStyle = .minimal
        return sb
    }()

    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📍 İstanbul", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .blue
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

    let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Tümü", "Konser", "Tiyatro", "Spor"])
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = .systemBlue
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        return sc
    }()

    let featuredLabel: UILabel = {
        let label = UILabel()
        label.text = "🎉 Öne Çıkan Etkinlikler"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .blue
        return label
    }()

    var eventCollectionView: UICollectionView!

    // MARK: - Timer
    var bannerTimer: Timer?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupScrollView()
        setupCollectionView()
        setupViews()
        setupConstraints()
        startBannerTimer()
    }

    // MARK: - Setup Functions

    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(locationButton)
        view.addSubview(bannerScrollView)
        view.addSubview(pageControl)
        view.addSubview(segmentControl)
        view.addSubview(featuredLabel)
        view.addSubview(eventCollectionView)
    }

    func setupScrollView() {
        bannerScrollView.delegate = self
        let bannerImages = ["banner1", "banner2", "banner3"] // Replace with real image names
        for (index, imageName) in bannerImages.enumerated() {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: CGFloat(index) * view.frame.width, y: 0,
                                     width: view.frame.width, height: 180)
            bannerScrollView.addSubview(imageView)
        }
        bannerScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(bannerImages.count), height: 180)
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10

        eventCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
        eventCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "eventCell")
        eventCollectionView.backgroundColor = .clear
    }

    func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        bannerScrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        featuredLabel.translatesAutoresizingMaskIntoConstraints = false
        eventCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            locationButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            bannerScrollView.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 16),
            bannerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerScrollView.heightAnchor.constraint(equalToConstant: 180),

            pageControl.topAnchor.constraint(equalTo: bannerScrollView.bottomAnchor, constant: 4),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            segmentControl.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 12),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            featuredLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 12),
            featuredLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            eventCollectionView.topAnchor.constraint(equalTo: featuredLabel.bottomAnchor, constant: 8),
            eventCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            eventCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            eventCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Banner Timer

    func startBannerTimer() {
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let nextPage = (self.pageControl.currentPage + 1) % self.pageControl.numberOfPages
            let offset = CGFloat(nextPage) * self.view.frame.width
            self.bannerScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            self.pageControl.currentPage = nextPage
        }
    }

    // MARK: - ScrollView Delegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerScrollView {
            let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
            pageControl.currentPage = Int(pageIndex)
        }
    }

    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // Dummy count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = eventCollectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath)
        cell.backgroundColor = .systemRed.withAlphaComponent(0.7)
        cell.layer.cornerRadius = 12
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 120)
    }
}

/*
import UIKit

class HomePageViewController: UIViewController {

    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("İstanbul, Türkiye ⌄", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()

    let categorySegment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Konser", "Tiyatro", "Stand-up", "Spor"])
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .white
        sc.selectedSegmentTintColor = .systemRed
        return sc
    }()

    let bannerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemGray6
        return scrollView
    }()

    let eventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Anasayfa"

        setupViews()
        setupConstraints()
        setupBanners()
    }

    func setupViews() {
        view.addSubview(locationButton)
        view.addSubview(categorySegment)
        view.addSubview(bannerScrollView)
        view.addSubview(eventCollectionView)
    }

    func setupConstraints() {
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        categorySegment.translatesAutoresizingMaskIntoConstraints = false
        bannerScrollView.translatesAutoresizingMaskIntoConstraints = false
        eventCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            locationButton.heightAnchor.constraint(equalToConstant: 44),

            categorySegment.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 12),
            categorySegment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categorySegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            bannerScrollView.topAnchor.constraint(equalTo: categorySegment.bottomAnchor, constant: 12),
            bannerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerScrollView.heightAnchor.constraint(equalToConstant: 160),

            eventCollectionView.topAnchor.constraint(equalTo: bannerScrollView.bottomAnchor, constant: 12),
            eventCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupBanners() {
        let bannerImages = ["banner1", "banner2", "banner3"] // Asset'e eklemen gerekir

        for (index, name) in bannerImages.enumerated() {
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: CGFloat(index) * view.frame.width,
                                     y: 0,
                                     width: view.frame.width,
                                     height: 160)
            bannerScrollView.addSubview(imageView)
        }

        bannerScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(bannerImages.count), height: 160)
    }
}*/
