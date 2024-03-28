import UIKit
import MapKit
import CoreLocation

class BusLocationsViewController: UIViewController {
    
    // MARK: - Properties
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let locationManager = CLLocationManager()
    var busLocations: [Vehicle] = []
    var timer: Timer?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        fetchLiveBusLocations() // Fetch live bus locations
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Bus Locations"
        
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Location Manager Setup
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Fetch Live Bus Locations
    
    private func fetchLiveBusLocations() {
        // Create URL object from the provided URL string
        let endpoint = "https://tfe-opendata.com/api/v1/vehicle_locations"
        
        if let url = URL(string: endpoint) {
            // Create a URLSession task for fetching data from the URL
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                // Check for errors
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                // Check if data is available
                guard let data = data else { return }
                
                do {
                    // Parse JSON data
                    let decoder = JSONDecoder()
                    let busLocationsResponseModel = try decoder.decode(BusLocationsResponseModel.self, from: data)
                    
                    print("DEBUG PRINT:", "success decoding")
                    
                    // Update bus locations
                    self.busLocations = busLocationsResponseModel.vehicles
                    self.addBusAnnotations()
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            
            // Start the URLSession task
            task.resume()
        } else {
            print("Invalid URL")
        }
    }
    
    // MARK: - Map Annotations
    
    private func addBusAnnotations() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mapView.removeAnnotations(self.mapView.annotations) // Clear previous annotations
            for vehicle in self.busLocations {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(updateBusLocations), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateBusLocations() {
        fetchLiveBusLocations() // Fetch live bus locations periodically
    }
}

// MARK: - CLLocationManagerDelegate

extension BusLocationsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}
