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



class HomeController: UIViewController, MKMapViewDelegate {
    
    
    
    // MARK: UI Components
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    let menuButton: UIButton = {
            let button = UIButton(type: .system)
            let image = UIImage(systemName: "list.dash") // Hamburger icon
            button.setImage(image, for: .normal)
            button.backgroundColor = .white
            button.tintColor = .systemBlue
            button.layer.cornerRadius = 10 // Set corner radius to create a rounded rectangle
            button.layer.masksToBounds = true // Clip sublayers to the rounded corners
            
            button.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside)
            return button
        }()
    
    let usernameLabel: CustomLabel = {
            let label = CustomLabel(text: "", fontSize: 16)
            label.hasBackground = true // Set background for the label
            return label
        }()
        
    
    
    var locationManager = CLLocationManager()
    let regionInMeters: Double = 10000

    
    // MARK: LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        checkLocationServices()
        
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            }
            
            if let user = user {
                self.usernameLabel.text = "Hello \(user.username)!"
            }
            
        }
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        

        self.view.addSubview(mapView)
        self.view.addSubview(menuButton)
        self.view.addSubview(usernameLabel)
                
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
         
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            menuButton.widthAnchor.constraint(equalToConstant: 40),
            menuButton.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 225),
            usernameLabel.widthAnchor.constraint(equalToConstant: 150),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)

            
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapMenu() {
        // Show the hamburger menu as a sidebar
        
        // Width of the sidebar menu
        let sidebarWidth: CGFloat = 250
        
        // Create the hamburger menu controller
        let hamburgerMenuController = HamburgerMenuController()
        
        // Set the frame of the hamburger menu
        hamburgerMenuController.view.frame = CGRect(x: -sidebarWidth, y: 0, width: sidebarWidth, height: view.frame.height)
        
        // Create an overlay view
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(overlayView)
        
        // Add a tap gesture recognizer to the overlay view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay(_:)))
        overlayView.addGestureRecognizer(tapGesture)
        
        // Add the hamburger menu as a child view controller
        addChild(hamburgerMenuController)
        view.addSubview(hamburgerMenuController.view)
        hamburgerMenuController.didMove(toParent: self)
        
        // Animate the sidebar menu to slide in from the left
        UIView.animate(withDuration: 0.3) {
            hamburgerMenuController.view.frame.origin.x = 0
        }
    }

    @objc private func didTapOverlay(_ sender: UITapGestureRecognizer) {
        // Dismiss the sidebar menu and return to HomeController
        
        // Width of the sidebar menu
        let sidebarWidth: CGFloat = 250
        
        // Find the hamburger menu controller
        guard let hamburgerMenuController = children.first as? HamburgerMenuController else {
            return
        }
        
        // Animate the sidebar menu to slide out to the left
        UIView.animate(withDuration: 0.3, animations: {
            hamburgerMenuController.view.frame.origin.x = -sidebarWidth
        }) { (_) in
            // Remove the overlay view and hamburger menu controller
            sender.view?.removeFromSuperview()
            hamburgerMenuController.removeFromParent()
        }
    }


    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                // setup our location manager
                self.setupLocationManager()
                self.checkLocationAuthorization()
            } else {
                AlertManager.showLocationDataError(on: self, title: "Location Permission", message: "Please turn on your location data to use the application.")
            }
        }
        
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
}

extension HomeController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
    }
    
    
}


