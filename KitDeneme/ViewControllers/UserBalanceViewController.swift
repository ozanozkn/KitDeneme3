//
//  UserBalanceViewController.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 17.04.2024.
//

import UIKit
import FirebaseAuth

class UserBalanceViewController: UIViewController {

    private let headerView = AuthHeaderView(title: "Balance", subTitle: "See balance / Scan card")
    
    private let userBalanceTextField: CustomTextField = {
        let textField = CustomTextField(fieldType: .username)
        textField.placeholder = "Balance"
        textField.isUserInteractionEnabled = false
        textField.textColor = .gray
        textField.textAlignment = .center
        return textField
        
    }()
    
    private let scanCardButton: CustomButton = {
        let button = CustomButton(title: "Scan Card", hasBackground: true, fontSize: .medium)
        button.addTarget(self, action: #selector(didTapScanCard), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.setupUI()
        self.fetchUser()
    }
    
    private func setupUI() {
        self.view.addSubview(userBalanceTextField)
        self.view.addSubview(headerView)
        self.view.addSubview(scanCardButton)
        
        userBalanceTextField.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        scanCardButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.userBalanceTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            self.userBalanceTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.userBalanceTextField.heightAnchor.constraint(equalToConstant: 55),
            self.userBalanceTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40),
            
            self.scanCardButton.topAnchor.constraint(equalTo: userBalanceTextField.bottomAnchor, constant: 22),
            self.scanCardButton.centerXAnchor.constraint(equalTo: userBalanceTextField.centerXAnchor),
            self.scanCardButton.heightAnchor.constraint(equalToConstant: 55),
            self.scanCardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            
        ])
    }
    
    private func fetchUser() {
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            }
            
            if let user = user {
                DispatchQueue.main.async {
                    self.userBalanceTextField.text = "Wallet: \(user.balance)₺"
                }
            }
        }
    }
    
    @objc private func didTapScanCard() {
        AlertManager.alertWIP(on: self)
        
    }
}
