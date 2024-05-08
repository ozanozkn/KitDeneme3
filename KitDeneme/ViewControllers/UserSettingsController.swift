//
//  UserSettingsController.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 20.03.2024.
//

import UIKit

class UserSettingsController: UIViewController {
    
    private let headerView = AuthHeaderView(title: String(localized: "User Settings", table: "Localizable"), subTitle: String(localized: "Security", table: "Localizable"))
    
    private let changePasswordImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "password.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let logoutImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logout.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let deleteAccountImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "deleteaccount.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
  
    private let logoutButton: CustomButton = {
        let button = CustomButton(title: String(localized: "Logout", table: "Localizable"), hasBackground: true, fontSize: .medium)
        button.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        return button
    }()
    
    private let changePasswordButton: CustomButton = {
        let button = CustomButton(title: String(localized: "Change Password", table: "Localizable"), hasBackground: true, fontSize: .medium)
        button.addTarget(self, action: #selector(didTapChangePassword), for: .touchUpInside)
        return button
    }()
    
    private let deleteAccountButton: CustomButton = {
        let button = CustomButton(title: String(localized: "Delete Account", table: "Localizable"), hasBackground: true, fontSize: .medium)
        button.addTarget(self, action: #selector(didTapDeleteAccount), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    

    private func setupUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(logoutButton)
        self.view.addSubview(changePasswordButton)
        self.view.addSubview(deleteAccountButton)
        self.view.addSubview(changePasswordImageView)
        self.view.addSubview(logoutImageView)
        self.view.addSubview(deleteAccountImageView)

        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.backgroundColor = UIColor(hex: "DE1616")
        logoutImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountButton.backgroundColor = UIColor(hex: "DE1616")
        deleteAccountImageView.translatesAutoresizingMaskIntoConstraints = false
        
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        changePasswordImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.changePasswordButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            self.changePasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            self.changePasswordButton.heightAnchor.constraint(equalToConstant: 55),
            self.changePasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            
            self.changePasswordImageView.centerYAnchor.constraint(equalTo: changePasswordButton.centerYAnchor),
            self.changePasswordImageView.trailingAnchor.constraint(equalTo: changePasswordButton.leadingAnchor, constant: -15),
            self.changePasswordImageView.widthAnchor.constraint(equalToConstant: 30),
            self.changePasswordImageView.heightAnchor.constraint(equalToConstant: 30),
            
            self.logoutButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 40),
            self.logoutButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            self.logoutButton.heightAnchor.constraint(equalToConstant: 55),
            self.logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            
            self.logoutImageView.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor),
            self.logoutImageView.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor, constant: -15),
            self.logoutImageView.widthAnchor.constraint(equalToConstant: 30),
            self.logoutImageView.heightAnchor.constraint(equalToConstant: 30),
            
            self.deleteAccountButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 40),
            self.deleteAccountButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.deleteAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            self.deleteAccountButton.heightAnchor.constraint(equalToConstant: 55),
            self.deleteAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            
            self.deleteAccountImageView.centerYAnchor.constraint(equalTo: deleteAccountButton.centerYAnchor),
            self.deleteAccountImageView.trailingAnchor.constraint(equalTo: deleteAccountButton.leadingAnchor, constant: -15),
            self.deleteAccountImageView.widthAnchor.constraint(equalToConstant: 30),
            self.deleteAccountImageView.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
    
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogoutError(on: self, with: error)
            }
        }
        
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthentication()
        }
    }
    
    @objc private func didTapChangePassword() {
            let changePasswordController = ChangePasswordController()
            navigationController?.pushViewController(changePasswordController, animated: true)
        }
    
    @objc private func didTapDeleteAccount() {
            let deleteAccountController = DeleteAccountController()
            navigationController?.pushViewController(deleteAccountController, animated: true)
        }
}
