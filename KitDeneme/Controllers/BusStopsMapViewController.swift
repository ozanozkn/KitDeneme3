import UIKit
import MapKit
import CoreLocation

class BusStopsMapViewController: UIViewController {
    
    // MARK: - Properties
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    var busStops: [Stop] = [] {
        didSet {
            addAnnotations()
        }
    }
    
    let locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        loadBusStopsData()
        
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Bus Stops"
        
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
    
    // MARK: - Bus Stops Data
    
    private func loadBusStopsData() {
        if let busStopsData = try? Data(contentsOf: Bundle.main.url(forResource: "bus_stops", withExtension: "json")!) {
            do {
                let busStopsResponseModel = try JSONDecoder().decode(BusStopsResponseModel.self, from: busStopsData)
                self.busStops = busStopsResponseModel.stops
                
                print("DEBUG PRINT:", "success decoding")
                
            } catch {
                print("Error decoding bus stops data: \(error)")
            }
        } else {
            print("Failed to load bus stops data")
        }
    }
    
    // MARK: - Map Annotations
    
    private func addAnnotations() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for stop in self.busStops {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
                annotation.title = stop.name
                annotation.subtitle = stop.locality
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension BusStopsMapViewController: CLLocationManagerDelegate {
    
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
