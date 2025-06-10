//
//  LocationViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {//CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource
    
    /*let tableView = UITableView()
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    var allEvents: [Event] = []
    var nearbyEvents: [Event] = []*/

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Yakınımdakiler"

        //setupTableView()
       // setupLocationManager()
    }
/*
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // Konum Alındığında
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLocation = location
        locationManager.stopUpdatingLocation()
        fetchEventsFromWebService()
    }

    // Web servisten etkinlikleri çek
    func fetchEventsFromWebService() {
        guard let url = URL(string: "http://localhost:8080/event/\(eventID)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let events = try JSONDecoder().decode([Event].self, from: data)
                self.allEvents = events
                self.filterNearbyEvents()
            } catch {
                print("Decode hatası: \(error)")
            }
        }.resume()
    }

    // Konuma göre filtreleme
    func filterNearbyEvents() {
        guard let userLocation = userLocation else { return }
        
        let geocoder = CLGeocoder()
        var filteredEvents: [Event] = []
        let dispatchGroup = DispatchGroup()

        for event in allEvents {
            dispatchGroup.enter()
            
            geocoder.geocodeAddressString(event.eventLocation!) { placemarks, error in
                defer { dispatchGroup.leave() }
                
                guard let coordinate = placemarks?.first?.location?.coordinate else { return }
                let eventLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let distance = userLocation.distance(from: eventLocation)
                
                if distance < 30000 { // 30 km yakınına kadar
                    filteredEvents.append(event)
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.nearbyEvents = filteredEvents
            self.tableView.reloadData()
        }
    }

    // Tablo görünümü
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nearbyEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = nearbyEvents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        cell.textLabel?.text = "\(event.eventName!) - \(event.eventType!)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // Detay sayfasına geçiş
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = nearbyEvents[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.eventID = selectedEvent.eventID
        navigationController?.pushViewController(detailVC, animated: true)
    }*/
}



/*
import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView = UITableView()
    private var events: [Event] = []
    private var userLocation: CLLocation?
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Yakınımda"
        view.backgroundColor = .white
        
        setupTableView()
        setupLocationManager()
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "EventCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchEventsFromWebService() {
        guard let url = URL(string: "http://localhost:8080/event/getAll") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("İstek hatası: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Durum Kodu: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("Beklenmeyen durum kodu.")
                    return
                }
            }

            guard let data = data else {
                print("Veri boş")
                return
            }

            do {
                let decoder = JSONDecoder()
                let fetchedEvents = try decoder.decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.events = self.sortEventsByDistance(events: fetchedEvents)
                    self.tableView.reloadData()
                }
            } catch {
                print("Veri çözümlenemedi: \(error)")
                if let str = String(data: data, encoding: .utf8) {
                    print("Gelen veri: \(str)")
                }
            }
        }.resume()
    }
    
    func sortEventsByDistance(events: [Event]) -> [Event] {
        guard let userLocation = userLocation else { return events }
        return events.sorted {
            guard
                let loc1 = getCoordinate(from: $0.eventLocation),
                let loc2 = getCoordinate(from: $1.eventLocation)
            else {
                return false
            }
            return userLocation.distance(from: loc1) < userLocation.distance(from: loc2)
        }
    }
    
    func getCoordinate(from address: String?) -> CLLocation? {
        guard let address = address else { return nil }
        var coordinate: CLLocation?
        let semaphore = DispatchSemaphore(value: 0)
        
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let loc = placemarks?.first?.location {
                coordinate = loc
            }
            semaphore.signal()
        }
        semaphore.wait()
        return coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        locationManager.stopUpdatingLocation()
        fetchEventsFromWebService()
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        let event = events[indexPath.row]
        cell.configure(with: event, userLocation: userLocation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        guard let address = event.eventLocation else { return }
        
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            guard let location = placemarks?.first?.location else { return }
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
            mapItem.name = event.eventName
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
}
*/




