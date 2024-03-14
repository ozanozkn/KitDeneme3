//
//  HomeController.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 8.03.2024.
//

import UIKit
import FirebaseAuth
import MapKit
import CoreLocation

class HomeController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    
    // MARK: UI Components
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    var locationManager:CLLocationManager!
    var currentLocationStr = "Current location"

    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Loading..."
        label.numberOfLines = 2
        return label
    }()
    
    
    
    // MARK: LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
//        AuthService.shared.fetchUser { [weak self] user, error in
//            guard let self = self else { return }
//            if let error = error {
//                AlertManager.showFetchingUserError(on: self, with: error)
//                return
//            }
//            
//            if let user = user {
//                self.label.text = "\(user.username)\n\(user.email)"
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))

//        self.view.addSubview(label)
        self.view.addSubview(mapView)
        
//        label.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            
//            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            
            
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapLogout() {
        
        AuthService.shared.signOut { error in
            if let error = error {
                AlertManager.showLogoutError(on: self, with: error)
            }
        }
        
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            
            sceneDelegate.checkAuthentication()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mapUserLocation: CLLocation = locations[0] as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: mapUserLocation.coordinate.latitude, longitude: mapUserLocation.coordinate.longitude)
        
        let mapRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(mapRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    
}



