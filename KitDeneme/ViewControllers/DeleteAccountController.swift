//
//  DeleteAccountController.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 27.03.2024.
//

import UIKit
import FirebaseAuth

class DeleteAccountController: UIViewController {
    
    private let headerView = AuthHeaderView(title: String(localized: "Delete Account", table: "Localizable"), subTitle: String(localized: "Enter your password to delete the account", table: "Localizable"))
    
    
    private let passwordField: CustomTextField = {
        let textField = CustomTextField(fieldType: .password)
        textField.placeholder = String(localized: "Password", table: "Localizable")
        return textField
    }()
    
    private let deleteAccountButton: CustomButton = {
        let button = CustomButton(title: String(localized: "Delete Account", table: "Localizable"), hasBackground: true, fontSize: .medium)
        button.addTarget(self, action: #selector(didTapDeleteAccount), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        self.setupUI()
        
    }
    
    private func setupUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(passwordField)
        self.view.addSubview(deleteAccountButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountButton.backgroundColor = UIColor(hex: "DE1616")
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.passwordField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.deleteAccountButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            self.deleteAccountButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.deleteAccountButton.heightAnchor.constraint(equalToConstant: 55),
            self.deleteAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
        ])
    }
    
    @objc private func didTapDeleteAccount() {
        guard let password = passwordField.text, !password.isEmpty else {
            showAlert(message: String(localized: "Please enter your password", table: "Localizable"))
            return
        }
        
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: password)
        
        user?.reauthenticate(with: credential) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: "Error: \(error.localizedDescription)")
            } else {
                // Ask for confirmation
                let confirmationAlert = UIAlertController(title: String(localized: "Confirmation", table: "Localizable"), message: String(localized: "Are you sure you want to delete your account?", table: "Localizable"), preferredStyle: .alert)
                confirmationAlert.addAction(UIAlertAction(title: String(localized: "Yes", table: "Localizable"), style: .destructive) { _ in
                    self.deleteAccount()
                })
                confirmationAlert.addAction(UIAlertAction(title: String(localized: "No", table: "Localizable"), style: .cancel, handler: nil))
                self.present(confirmationAlert, animated: true, completion: nil)
            }
        }
    }
    
    private func deleteAccount() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        Auth.auth().currentUser?.delete { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: "Error: \(error.localizedDescription)")
            } else {
                print("call works and doc deleted")
                self.showAlertWithCompletion(message: String(localized: "Account deleted successfully.", table: "Localizable")) {
                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.checkAuthentication()
                    }
                }
            }
            
        }
        
        AuthService.shared.deleteUserData(forUserID: userID) { error in
            if error != nil {
                print("error in calling")
            } else {
                print("success calling")
            }
            
        }
        
            
        
        
        
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "OK", table: "Localizable"), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    private func showAlertWithCompletion(message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "OK", table: "Localizable"), style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Tap Gesture Recognizer

    func textFieldDidBeginEditing(_ textField: UITextField) {
            // Open the keyboard when a text field is clicked
            textField.becomeFirstResponder()
        }
                
        
    @objc private func dismissKeyboard() {
        
        // Dismiss the keyboard when tapping outside of the text fields
        
        view.endEditing(true)
        
    }
}
