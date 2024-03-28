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
    private var viewModel = BusLocationsViewModel() // Create an instance of BusLocationsViewModel
    private var busLocations: [Vehicle] = [] // Store the fetched bus locations
    private var timer: Timer? // Timer to periodically update bus locations
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        
        mapView.delegate = self // Set the delegate
        
        // Set the view model delegate
        viewModel.delegate = self
        // Start fetching live bus locations
        viewModel.fetchLiveBusLocations()
        
        // Start the timer to update bus locations every 15 seconds
        startTimer()
    }
    
    deinit {
        stopTimer() // Invalidate the timer when the view controller is deallocated
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
    
    // MARK: - Timer
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(updateBusLocations), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateBusLocations() {
        viewModel.fetchLiveBusLocations() // Fetch live bus locations periodically
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

// MARK: - MKMapViewDelegate

extension BusLocationsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "busAnnotation"
        var annotationView: MKAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = dequeuedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        
        // Set the annotation image
        annotationView.image = UIImage(named: "bus")
        
        // Set the frame for the annotation view
        annotationView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        return annotationView
    }
}

// MARK: - BusLocationsViewModelDelegate

extension BusLocationsViewController: BusLocationsViewModelDelegate {
    func didUpdateBusLocations(_ locations: [Vehicle]) {
        busLocations = locations // Update the stored bus locations
        addBusAnnotations() // Add annotations to the map
    }
    
    func didFailFetchingBusLocations(with error: Error) {
        print("Error fetching bus locations: \(error)")
    }
    
    private func addBusAnnotations() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mapView.removeAnnotations(self.mapView.annotations) // Clear previous annotations
            for vehicle in self.busLocations {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
                annotation.title = "Journey: " + (vehicle.journeyID ?? "TBD")
                annotation.subtitle = "Destination: " + (vehicle.destination ?? "TBD")
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}
