//
//  RegisterViewModel.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 29.03.2024.
//

import Foundation

protocol RegisterViewModelDelegate: AnyObject {
    func registrationDidSucceed()
    func registrationDidFail(with error: Error)
}

class RegisterViewModel {
    weak var delegate: RegisterViewModelDelegate?

    func registerUser(username: String, email: String, password: String) {
        // Perform user registration logic
        
        // Example implementation
        AuthService.shared.registerUser(with: RegisterUserRequest(username: username, email: email, password: password)) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.registrationDidFail(with: error)
            } else if wasRegistered {
                // Registration succeeded, notify the delegate
                self.sendEmailVerification()
                
            } else {
                // Registration failed
                self.delegate?.registrationDidFail(with: NSError(domain: "Application", code: 0, userInfo: [NSLocalizedDescriptionKey: "Registration failed"]))
            }
        }
    }

    func sendEmailVerification() {
        // Perform sending email verification logic
        AuthService.shared.sendEmailVerification { success, error in
            if let error = error {
                print("Error sending email verification \(error.localizedDescription)")
            } else {
                print("Email verification sent successfully")
                self.delegate?.registrationDidSucceed()
            }
        }
    }
}
