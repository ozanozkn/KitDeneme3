//
//  ForgotPasswordViewController.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 8.03.2024.
//

import UIKit

class ForgotPasswordController: UIViewController {

        
    
    // MARK: UI Components
    private let headerView = AuthHeaderView(title: String(localized: "Forgot Password", table: "Localizable"), subTitle: String(localized: "Reset your password", table: "Localizable"))
    
    private let emailField = CustomTextField(fieldType: .email)
    
    private let resetPasswordButton = CustomButton(title: String(localized: "Submit", table: "Localizable"), hasBackground: true, fontSize: .big)

    
    // MARK: LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        self.resetPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(resetPasswordButton)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 230),

            
            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 11),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.resetPasswordButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.resetPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            self.resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
        ])
    }
    
    // MARK: - Selectors
    @objc private func didTapForgotPassword() {
        let email = self.emailField.text ?? ""
        
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showErrorSendingPasswordReset(on: self, with: error)
                return
            }
            
            AlertManager.showPasswordResetSent(on: self)
        }
        
        // TODO: - Email validation
    }
  
    func textFieldDidBeginEditing(_ textField: UITextField) {
            // Open the keyboard when a text field is clicked
            textField.becomeFirstResponder()
        }
        
        // MARK: - Tap Gesture Recognizer
        
        @objc private func dismissKeyboard() {
            // Dismiss the keyboard when tapping outside of the text fields
            view.endEditing(true)
        }
}
