//
//  AlertManager.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 8.03.2024.
//

import UIKit

class AlertManager {
    
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?){
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: String(localized: "Dismiss", table: "Localizable"), style: .default, handler: nil))
            
            vc.present(alert, animated: true)
        }
    }
}

// MARK: - Show Validation Alerts
extension AlertManager {
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: String(localized: "Invalid Email", table: "Localizable"), message: String(localized: "Please enter a valid email", table: "Localizable"))
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: String(localized: "Invalid Password", table: "Localizable"), message: String(localized: "Please enter a valid password", table: "Localizable"))
    }
    
    public static func showInvalidUsernameAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: String(localized: "Invalid Username", table: "Localizable"), message: String(localized: "Please enter a valid username", table: "Localizable"))
    }
}

// MARK: - Registration Errors
extension AlertManager {
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: String(localized: "Unknown Registration Error", table: "Localizable"), message: nil)
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: String(localized: "Unknown Registration Error", table: "Localizable"), message: "\(error.localizedDescription)")
    }
}

// MARK: - Log In Errors
extension AlertManager {
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: String(localized: "Error Signing In", table: "Localizable"), message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: String(localized: "Error Signing In", table: "Localizable"), message: String(localized: "The email/password you entered is incorrect", table: "Localizable"))
    }
}

// MARK: - Log Out Errors
extension AlertManager {
    public static func showLogoutError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: String(localized: "Log Out Error", table: "Localizable"), message: "\(error.localizedDescription)")
    }
}


// MARK: - Forgot Password
extension AlertManager {
    public static func showPasswordResetSent(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: String(localized: "Password Reset", table: "Localizable"), message: String(localized: "Password reset mail has been sent to your email address.", table: "Localizable"))
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: String(localized: "Error Reseting Password", table: "Localizable"), message: "\(error.localizedDescription)")
    }
}

// MARK: - Fetching User Errors

extension AlertManager {
    public static func showFetchingUserError(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, title: String(localized: "Error Fetching User", table: "Localizable"), message: "\(error.localizedDescription)")
    }
    
    public static func showUnknownFetchingUserError(on vc: UIViewController) {
        showBasicAlert(on: vc, title: String(localized: "Unknown Error Fetching User", table: "Localizable"), message: nil)
    }
}


extension AlertManager {
    public static func showLocationDataError(on vc: UIViewController, title: String, message: String) {
        showBasicAlert(on: vc, title: String(localized: "Error Fetching User's Location", table: "Localizable"), message: nil)
    }
}

extension AlertManager {
    public static func showConnectionError(on vc: UIViewController) {
        showBasicAlert(on: vc, title: String(localized: "Error Connecting to the Internet", table: "Localizable"), message: nil)
    }
}

extension AlertManager {
    public static func mailVerificationSent(on vc: UIViewController) {
        showBasicAlert(on: vc, title: String(localized: "Verification Sent", table: "Localizable"), message: String(localized: "Please verify your email", table: "Localizable"))
    }
}

extension AlertManager {
    public static func alertWIP(on vc: UIViewController) {
        showBasicAlert(on: vc, title: String(localized: "WIP", table: "Localizable"), message: String(localized: "This function is currently in work in progress", table: "Localizable"))
    }
}

extension AlertManager {
    public static func alertRestartApp(on vc: UIViewController) {
        showBasicAlert(on: vc, title: String(localized: "Restart Required", table: "Localizable"), message: String(localized: "Your app needs to be restarted to change the language", table: "Localizable"))
    }
}

extension AlertManager {
    public static func showEmailNotFound(on vc: UIViewController) {
        showBasicAlert(on: vc, title: String(localized: "Email Not Found", table: "Localizable"), message: String(localized: "The email you entered is not found", table: "Localizable"))
    }
}

extension AlertManager {
    public static func showEmailAlreadyInUse(on vc: UIViewController) {
        showBasicAlert(on: vc, title: String(localized: "Email Already In Use", table: "Localizable"), message: String(localized: "The email you entered is already in use", table: "Localizable"))
    }
}
