//
//  CustomTextField.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 8.03.2024.
//

import UIKit

class CustomTextField: UITextField {

    enum CustomTextFieldType {
        case username
        case email
        case password
    }
    
    private let authFieldType: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .username:
            self.placeholder = String(localized: "Username", table: "Localizable")
        case .email:
            self.placeholder = String(localized: "Email", table: "Localizable")
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = String(localized: "Password", table: "Localizable")
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
}

extension UITextField {
    func setValidation(isValid: Bool) {
        layer.borderWidth = isValid ? 0 : 1 // 0 for valid, 1 for invalid
        layer.borderColor = isValid ? UIColor.clear.cgColor : UIColor.red.cgColor
    }
}
