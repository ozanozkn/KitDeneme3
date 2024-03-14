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
                AlertManager.showInvalidEmailAlert(on: LoginController())
                
                print("DEBUG PRINT:", "must show alert")
                
            }
        }
    
    public func startMonitoringNetworkReachability() {
            networkReachability = NetworkReachabilityManager.default
            networkReachability?.startListening(onUpdatePerforming: { [weak self] status in
                switch status {
                case .notReachable:
                    self?.showAlert(title: "Nope Internet Connection", message: "Please check your internet connection.")
                case .reachable(_), .unknown:
                    self?.showAlert(title: "Connected!", message: "")
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
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
}
