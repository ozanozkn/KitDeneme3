import UIKit
import FirebaseAuth

class ChangePasswordController: UIViewController {
    
    // MARK: - Properties
    private let headerView = AuthHeaderView(title: "Change Password", subTitle: "Change your password")
    
        private let currentPasswordField: CustomTextField = {
            let textField = CustomTextField(fieldType: .password)
            textField.placeholder = "Current Password"
            return textField
        }()
        
        private let newPasswordField: CustomTextField = {
            let textField = CustomTextField(fieldType: .password)
            textField.placeholder = "New Password"
            return textField
        }()
        
        private let changePasswordButton: CustomButton = {
            let button = CustomButton(title: "Change Password", hasBackground: true, fontSize: .medium)
            button.addTarget(self, action: #selector(didTapChangePassword), for: .touchUpInside)
            return button
        }()
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            setupUI()
        }
        
        // MARK: - UI Setup
        
        private func setupUI() {
            
            self.view.addSubview(headerView)
            self.view.addSubview(currentPasswordField)
            self.view.addSubview(newPasswordField)
            self.view.addSubview(changePasswordButton)
            
            headerView.translatesAutoresizingMaskIntoConstraints = false
            currentPasswordField.translatesAutoresizingMaskIntoConstraints = false
            newPasswordField.translatesAutoresizingMaskIntoConstraints = false
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
                
                self.changePasswordButton.topAnchor.constraint(equalTo: newPasswordField.bottomAnchor, constant: 22),
                self.changePasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.changePasswordButton.heightAnchor.constraint(equalToConstant: 55),
                self.changePasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
               
            ])
        }
    
    
    // MARK: - Actions
    
    @objc private func didTapChangePassword() {
        guard let currentPassword = currentPasswordField.text, !currentPassword.isEmpty,
              let newPassword = newPasswordField.text, !newPassword.isEmpty else {
            showAlert(message: "Please enter both current and new password.")
            return
        }
        
        if !Validator.isPasswordValid(for: newPassword) {
            showAlert(message: "Please enter a valid password")
            return
        }
        
        // Retrieve user's current password from Firebase Authentication
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "User not authenticated.")
            return
        }
        
        user.reauthenticate(with: EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                // Show an alert if reauthentication fails
                self.showAlert(message: "Error changing password, please fill the fields correctly")
                return
            }
            
            // Reauthentication succeeded, proceed with changing the password
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    // Show an alert if changing the password fails
                    self.showAlert(message: "Failed to change password: \(error.localizedDescription)")
                } else {
                    // Password changed successfully
                    self.showAlertWithCompletion(message: "Password changed successfully.") {
                        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                            sceneDelegate.checkAuthentication()
                        }
                    }
                    self.currentPasswordField.text = ""
                    self.newPasswordField.text = ""
                }
            }
        }
        

    }
    
    // MARK: - Helper Methods
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlertWithCompletion(message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }

}
