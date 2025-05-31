//
//  LocationViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//
import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    let locationSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Adres arayın"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let routeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Git", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var eventAddress: String?
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    var searchedCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Yakınımda"
        // Setup delegates
        locationManager.delegate = self
        mapView.delegate = self
        locationSearchBar.delegate = self
        
        // Layout
        setupLayout()
        
        // Location auth
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Button target
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
    }
    
    func setupLayout() {
        view.addSubview(locationSearchBar)
        view.addSubview(mapView)
        view.addSubview(routeButton)
        
        NSLayoutConstraint.activate([
            locationSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mapView.topAnchor.constraint(equalTo: locationSearchBar.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            routeButton.widthAnchor.constraint(equalToConstant: 60),
            routeButton.heightAnchor.constraint(equalToConstant: 40),
            routeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            routeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func routeButtonTapped() {
        guard let destinationCoordinate = searchedCoordinate else {
            print("Henüz arama yapılmadı veya konum bulunamadı.")
            return
        }
        openAppleMaps(with: destinationCoordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location.coordinate
            locationManager.stopUpdatingLocation()
            if let address = eventAddress {
                geocodeAddressAndOpenMaps(address)
            }
        }
    }
    
    func geocodeAddressAndOpenMaps(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("Adres bulunamadı: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            let destinationCoordinate = location.coordinate
            self.openAppleMaps(with: destinationCoordinate)
        }
    }
    
    func openAppleMaps(with destinationCoordinate: CLLocationCoordinate2D) {
        guard let userLocation = userLocation else {
            print("Kullanıcı konumu alınamadı.")
            return
        }
        
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let userMapItem = MKMapItem(placemark: userPlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = "Etkinlik Mekanı"
        
        let options: [String: Any] = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        MKMapItem.openMaps(with: [userMapItem, destinationMapItem], launchOptions: options)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchBar.resignFirstResponder()
        geocodeAddressFromSearchBar(searchText)
    }
    
    func geocodeAddressFromSearchBar(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Adres aranırken hata: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("Adres bulunamadı.")
                return
            }
            
            let coordinate = location.coordinate
            self.searchedCoordinate = coordinate
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Aranan Konum"
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(region, animated: true)
        }
    }
}
