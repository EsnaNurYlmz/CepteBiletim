//
//  LocationViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//
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





