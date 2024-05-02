//
//  ConnectivityManager.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 14.03.2024.
//

import Foundation

import Alamofire
import UIKit

class ConnectivityManager: NSObject {
    
    var window: UIWindow?
    var networkReachability: NetworkReachabilityManager?
    
    public func checkInternetConnection() {
        
        print("DEBUG PRINT:", "checked internet connection")
        
            if !(NetworkReachabilityManager.default?.isReachable ?? false) {
                AlertManager.showConnectionError(on: LoginController())
                
                print("DEBUG PRINT:", "must show alert")
                
            }
        }
    
    public func startMonitoringNetworkReachability() {
            networkReachability = NetworkReachabilityManager.default
            networkReachability?.startListening(onUpdatePerforming: { [weak self] status in
                switch status {
                case .notReachable:
                    self?.showAlert(title: String(localized: "No Internet Connection", table: "Localizable"), message: String(localized: "Please check your internet connection.", table: "Localizable"))
                case .reachable(_), .unknown:
                    self?.showAlert(title: String(localized: "Connected!", table: "Localizable"), message: String(localized: "Connection established.", table: "Localizable"))
                    break
                }
            })
        
        print("DEBUG PRINT:", "monitoring started")
        
        }
    
    public func stopMonitoringNetworkReachability() {
        networkReachability?.stopListening()
        print("DEBUG PRINT:", "monitoring stopped")
        }
    
    public func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String(localized: "OK", table: "Localizable"), style: .default, handler: nil)
            alertController.addAction(okAction)
            window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
}
