import UIKit

class RegisterController: UIViewController {
    
    private let headerView = AuthHeaderView(title: String(localized: "Sign Up", table: "Localizable"), subTitle: String(localized: "Create your account", table: "Localizable"))
    
    private let usernameField = CustomTextField(fieldType: .username)
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signUpButton = CustomButton(title: String(localized: "Sign Up", table: "Localizable"), hasBackground: true, fontSize: .big)
    private let signInButton = CustomButton(title: String(localized: "Already have an account? Sign In.", table: "Localizable"), fontSize: .medium)
    
    private let termsTextView: UITextView = {
            let attributedString = NSMutableAttributedString(string: String(localized: "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy.", table: "Localizable"))
            
        attributedString.addAttribute(.link, value: "terms://termsAndConditions", range: (attributedString.string as NSString).range(of: String(localized: "Terms & Conditions", table: "Localizable")))
            
        attributedString.addAttribute(.link, value: "privacy://privacyPolicy", range: (attributedString.string as NSString).range(of: String(localized: "Privacy Policy", table: "Localizable")))
            
            let tv = UITextView()
            tv.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
            tv.backgroundColor = .clear
            tv.attributedText = attributedString
            tv.textColor = .label
            tv.isSelectable = true
            tv.isEditable = false
            tv.delaysContentTouches = false
            tv.isScrollEnabled = false
            return tv
        }()
    
    private var viewModel: RegisterViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        self.termsTextView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    private func setupUI() {
            self.view.backgroundColor = .systemBackground
            
            self.view.addSubview(headerView)
            self.view.addSubview(usernameField)
            self.view.addSubview(emailField)
            self.view.addSubview(passwordField)
            self.view.addSubview(signUpButton)
            self.view.addSubview(termsTextView)
            self.view.addSubview(signInButton)


            self.headerView.translatesAutoresizingMaskIntoConstraints = false
            self.usernameField.translatesAutoresizingMaskIntoConstraints = false
            self.emailField.translatesAutoresizingMaskIntoConstraints = false
            self.passwordField.translatesAutoresizingMaskIntoConstraints = false
            self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
            self.termsTextView.translatesAutoresizingMaskIntoConstraints = false
            self.signInButton.translatesAutoresizingMaskIntoConstraints = false
            
            
            NSLayoutConstraint.activate([
                self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.headerView.heightAnchor.constraint(equalToConstant: 222),
                
                self.usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
                self.usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.usernameField.heightAnchor.constraint(equalToConstant: 55),
                self.usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 22),
                self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.emailField.heightAnchor.constraint(equalToConstant: 55),
                self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
                self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.passwordField.heightAnchor.constraint(equalToConstant: 55),
                self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
                self.signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.signUpButton.heightAnchor.constraint(equalToConstant: 55),
                self.signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.termsTextView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 6),
                self.termsTextView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.termsTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                self.signInButton.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 11),
                self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                self.signInButton.heightAnchor.constraint(equalToConstant: 44),
                self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
                
                
            ])
        }
    
    private func setupViewModel() {
        viewModel = RegisterViewModel()
        viewModel.delegate = self
    }
    
    // MARK: - Text Field Validation
        
    private func updateTextFieldValidation() {
        // Validate username
        let isUsernameValid = Validator.isValidUsername(for: usernameField.text ?? "")
        usernameField.setValidation(isValid: isUsernameValid)
        
        // Validate email
        let isEmailValid = Validator.isValidEmail(for: emailField.text ?? "")
        emailField.setValidation(isValid: isEmailValid)
        
        // Validate password
        let isPasswordValid = Validator.isPasswordValid(for: passwordField.text ?? "")
        passwordField.setValidation(isValid: isPasswordValid)
        
    }
    
    @objc private func didTapSignUp() {
        // Validate text fields
        updateTextFieldValidation()
               
         
        
        let registerUserRequest = RegisterUserRequest(
                    username: self.usernameField.text ?? "",
                    email: self.emailField.text ?? "",
                    password: self.passwordField.text ?? ""
                
        )
    //        Username check
            if !Validator.isValidUsername(for: registerUserRequest.username) {
                AlertManager.showInvalidUsernameAlert(on: self)
                return
            }
            
    //        mail check
            if !Validator.isValidEmail(for: registerUserRequest.email) {
                AlertManager.showInvalidEmailAlert(on: self)
                return
            }
            
    //        Username check
            if !Validator.isPasswordValid(for: registerUserRequest.password) {
                AlertManager.showInvalidPasswordAlert(on: self)
                return
            }
        
        AuthService.shared.isEmailRegistered(registerUserRequest.email) { isRegistered, error in
            if let error = error {
                print("Error checking email registration:", error)
                // Show an alert for error
                return
            }
            
            if isRegistered {
                AlertManager.showEmailAlreadyInUse(on: self)
            } else {
                self.viewModel.registerUser(username: registerUserRequest.username, email: registerUserRequest.email, password: registerUserRequest.password)
            }
            
        }
        
        
    }
    
    @objc private func didTapSignIn() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension RegisterController: RegisterViewModelDelegate {

    func registrationDidSucceed() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: String(localized: "Email Verification", table: "Localizable"), message: String(localized: "Verification mail sent, please verify your email address", table: "Localizable"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: String(localized: "OK", table: "Localizable"), style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            })
            self.present(alert, animated: true, completion: nil)
        }
    }

    func registrationDidFail(with error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: String(localized: "Registration Error", table: "Localizable"), message: String(localized: "Failed to register. Please try again later.", table: "Localizable"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension RegisterController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "terms" {
            self.showWebViewerController(with: "https://policies.google.com/terms?hl=en")
        } else if URL.scheme == "privacy" {
            self.showWebViewerController(with: "https://policies.google.com/privacy?hl=en")
        }
        
        return true
    }
    
    private func showWebViewerController(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}

