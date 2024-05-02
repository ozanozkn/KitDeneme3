//
//  SceneDelegate.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 7.03.2024.
//

import UIKit
import FirebaseAuth
import Alamofire

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var networkReachability: NetworkReachabilityManager?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        
        self.checkAuthentication()
        
        self.startMonitoringNetworkReachability()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.checkInternetConnection()
        }
//
        
    }

    private func setupWindow(with scene: UIScene) {
        
            guard let windowScene = (scene as? UIWindowScene) else { return }
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            self.window?.makeKeyAndVisible()
            
    }

    
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            self.goToController(with: LoginController())
        } else {
            if Auth.auth().currentUser!.isEmailVerified {
                self.goToController(with: HomeController())
            } else {
                self.goToController(with: LoginController())
            }
        }
        
    }

     func goToController(with viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in
                let nav = UINavigationController(rootViewController: viewController)
                nav.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = nav
                
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
    
    private func checkInternetConnection() {
            if !(NetworkReachabilityManager.default?.isReachable ?? false) {
                self.showAlert(title: String(localized: "No Internet Connection", table: "Localizable"), message: String(localized: "Please check your internet connection and try again.", table: "Localizable"))
                
            }
        }
    
    func startMonitoringNetworkReachability() {
            networkReachability = NetworkReachabilityManager.default
            networkReachability?.startListening(onUpdatePerforming: { [weak self] status in
                switch status {
                case .notReachable:
                    self?.showAlert(title: String(localized: "No Internet Connection", table: "Localizable"), message: String(localized: "Please check your internet connection and try again.", table: "Localizable"))
                    break
                case .reachable:
                    self?.showAlert(title: String(localized: "Connection Established", table: "Localizable"), message: String(localized: "Your connection to our servers has been established", table: "Localizable"))
                    break
                case .unknown:
                    self?.showAlert(title: String(localized: "An Error Has Occured", table: "Localizable"), message: "")
                    break
                }
            })
        }
    
    
    func stopMonitoringNetworkReachability() {
            networkReachability?.stopListening()
        
        }
    
    private func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String(localized: "OK", table: "Localizable"), style: .default, handler: nil)
            alertController.addAction(okAction)
            window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
}

