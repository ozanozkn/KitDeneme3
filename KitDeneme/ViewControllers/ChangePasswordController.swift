import UIKit
import FirebaseAuth

class ChangePasswordController: UIViewController {
    
    // MARK: - Properties
    private let headerView = AuthHeaderView(title: String(localized: "Change Password", table: "Localizable"), subTitle: String(localized: "Change your password", table: "Localizable"))
    
    private let currentPasswordField: CustomTextField = {
        let textField = CustomTextField(fieldType: .password)
        textField.placeholder = String(localized: "Current Password", table: "Localizable")
        return textField
        
    }()
        
    private let newPasswordField: CustomTextField = {
        let textField = CustomTextField(fieldType: .password)
        textField.placeholder = String(localized: "New Password", table: "Localizable")
        return textField
        
    }()
    
    private let newPasswordAgainField: CustomTextField = {
        let textField = CustomTextField(fieldType: .password)
        textField.placeholder = String(localized: "New Password Again", table: "Localizable")
        return textField
    }()
        
    private let changePasswordButton: CustomButton = {
        let button = CustomButton(title: String(localized: "Change Password", table: "Localizable"), hasBackground: true, fontSize: .medium)
        button.addTarget(self, action: #selector(didTapChangePassword), for: .touchUpInside)
        return button
        
    }()
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .systemBackground
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
            
            setupUI()
        }
        
        // MARK: - UI Setup
        
        private func setupUI() {
            
            self.view.addSubview(headerView)
            self.view.addSubview(currentPasswordField)
            self.view.addSubview(newPasswordField)
            self.view.addSubview(newPasswordAgainField)
            self.view.addSubview(changePasswordButton)
            
            headerView.translatesAutoresizingMaskIntoConstraints = false
            currentPasswordField.translatesAutoresizingMaskIntoConstraints = false
            newPasswordField.translatesAutoresizingMaskIntoConstraints = false
            newPasswordAgainField.translatesAutoresizingMaskIntoConstraints = false
            changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.headerView.heightAnchor.constraint(equalToConstant: 222),
                
                self.currentPasswordField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
                self.currentPasswordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.currentPasswordField.heightAnchor.constraint(equalToConstant: 55),
                self.currentPasswordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.newPasswordField.topAnchor.constraint(equalTo: currentPasswordField.bottomAnchor, constant: 22),
                self.newPasswordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.newPasswordField.heightAnchor.constraint(equalToConstant: 55),
                self.newPasswordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.newPasswordAgainField.topAnchor.constraint(equalTo: newPasswordField.bottomAnchor, constant: 22),
                self.newPasswordAgainField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.newPasswordAgainField.heightAnchor.constraint(equalToConstant: 55),
                self.newPasswordAgainField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.changePasswordButton.topAnchor.constraint(equalTo: newPasswordAgainField.bottomAnchor, constant: 22),
                self.changePasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.changePasswordButton.heightAnchor.constraint(equalToConstant: 55),
                self.changePasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
               
            ])
        }
    
    
    // MARK: - Actions
    
    private func updateTextFieldValidation() {
        
        // Validate password
        let isPasswordValid = Validator.isPasswordValid(for: currentPasswordField.text ?? "")
        currentPasswordField.setValidation(isValid: isPasswordValid)
        
        // Validate password
        let isNewPasswordValid = Validator.isPasswordValid(for: newPasswordField.text ?? "")
        newPasswordField.setValidation(isValid: isNewPasswordValid)
        
        let isNewPasswordAgainValid = Validator.isPasswordValid(for: newPasswordAgainField.text ?? "")
        newPasswordAgainField.setValidation(isValid: isNewPasswordAgainValid)
        
        
        
    }
    
    @objc private func didTapChangePassword() {
        updateTextFieldValidation()
        
        guard let currentPassword = currentPasswordField.text, !currentPassword.isEmpty,
                let newPassword = newPasswordField.text, !newPassword.isEmpty,
                let newPasswordAgain = newPasswordAgainField.text, !newPasswordAgain.isEmpty else {
            showAlert(message: String(localized: "Please fill in all fields.", table: "Localizable"))
            return
               
        }
        
        if !Validator.isPasswordValid(for: newPassword) {
            showAlert(message: String(localized: "Please enter a valid password", table: "Localizable"))
            return
        }
        
        if newPassword != newPasswordAgain {
            showAlert(message: String(localized: "New password fields must match." ,table: "Localizable"))
            return
        }
        
        // Retrieve user's current password from Firebase
        guard let user = Auth.auth().currentUser else {
            showAlert(message: String(localized: "User not authenticated.", table: "Localizable"))
            return
        }
        
        user.reauthenticate(with: EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)) { [weak self] _, error in
            guard let self = self else { return }
            if error != nil {
                // Show an alert if reauthentication fails
                self.showAlert(message: String(localized: "Error changing password, please fill the fields correctly", table: "Localizable"))
                return
            }
            
            // Reauthentication succeeded, proceed with changing the password
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    // Show an alert if changing the password fails
                    self.showAlert(message: "Failed to change password: \(error.localizedDescription)")
                } else {
                    // Password changed successfully
                    self.showAlertWithCompletion(message: String(localized: "Password changed successfully.", table: "Localizable")) {
                        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                            sceneDelegate.checkAuthentication()
                        }
                    }
                    self.currentPasswordField.text = ""
                    self.newPasswordField.text = ""
                    self.newPasswordAgainField.text = ""
                }
            }
        }
        

    }
    
    // MARK: - Helper Methods
    
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
