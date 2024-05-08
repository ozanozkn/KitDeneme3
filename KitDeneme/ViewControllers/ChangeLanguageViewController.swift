//
//  ChangeLanguageViewController.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 26.04.2024.
//
import UIKit

class ChangeLanguageViewController: UIViewController {
    
    private let headerView = AuthHeaderView(title: String(localized: "Change Language", table: "Localizable"), subTitle: String(localized: "Change to your desired language", table: "Localizable"))
    
    private let turkishButton = CustomButton(title: "Türkçe", hasBackground: true, fontSize: .medium)
    
    private let turkishImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "turkish.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let englishButton = CustomButton(title: "English", hasBackground: true, fontSize: .medium)
    
    private let englishImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "english.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let saveButton = CustomButton(title: String(localized: "Save", table: "Localizable"), hasBackground: true, fontSize: .big)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.view.backgroundColor = .systemBackground
        
        turkishButton.addTarget(self, action: #selector(didTapTurkishButton), for: .touchUpInside)
        englishButton.addTarget(self, action: #selector(didTapEnglishButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        self.loadLanguage()
    }
    
    private func setupUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(turkishButton)
        self.view.addSubview(turkishImageView)
        self.view.addSubview(englishButton)
        self.view.addSubview(englishImageView)
        self.view.addSubview(saveButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        turkishButton.translatesAutoresizingMaskIntoConstraints = false
        turkishImageView.translatesAutoresizingMaskIntoConstraints = false
        englishButton.translatesAutoresizingMaskIntoConstraints = false
        englishImageView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        turkishButton.backgroundColor = UIColor(hex: "FFE797")
        englishButton.backgroundColor = UIColor(hex: "FFE797")
        turkishButton.setTitleColor(.black, for: .normal)
        englishButton.setTitleColor(.black, for: .normal)
        
        NSLayoutConstraint.activate([
            
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.turkishButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            self.turkishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            self.turkishButton.heightAnchor.constraint(equalToConstant: 45),
            self.turkishButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            
            self.turkishImageView.centerYAnchor.constraint(equalTo: turkishButton.centerYAnchor),
            self.turkishImageView.trailingAnchor.constraint(equalTo: turkishButton.leadingAnchor, constant: -15),
            self.turkishImageView.widthAnchor.constraint(equalToConstant: 30),
            self.turkishImageView.heightAnchor.constraint(equalToConstant: 30),
            
            self.englishButton.topAnchor.constraint(equalTo: turkishButton.bottomAnchor, constant: 30),
            self.englishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            self.englishButton.heightAnchor.constraint(equalToConstant: 45),
            self.englishButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            
            self.englishImageView.centerYAnchor.constraint(equalTo: englishButton.centerYAnchor),
            self.englishImageView.trailingAnchor.constraint(equalTo: englishButton.leadingAnchor, constant: -15),
            self.englishImageView.widthAnchor.constraint(equalToConstant: 30),
            self.englishImageView.heightAnchor.constraint(equalToConstant: 30),
            
            self.saveButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.saveButton.heightAnchor.constraint(equalToConstant: 55),
            self.saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            
        ])
        
        
        
    }
    
    
    @objc func didTapTurkishButton() {
        updateButtonColorForLanguage(selectedLanguage: "tr")
    }
    
    @objc func didTapEnglishButton() {
        updateButtonColorForLanguage(selectedLanguage: "en")
        
    }
    
    @objc func didTapSaveButton() {
        guard let selectedLanguage = getCurrentSelectedLanguage() else { return }
        
        
        // Switch app language and reload UI
        Bundle.setLanguage(selectedLanguage)
        UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
                
        AlertManager.alertRestartApp(on: self)
        
        
    }
    
    private func updateButtonColorForLanguage(selectedLanguage: String) {
        let unselectedColor = UIColor(hex: "FFE797") // Default color
        let selectedColor = UIColor(hex: "F5BE0B") // Selected color
        
        // Reset button colors
        turkishButton.backgroundColor = unselectedColor
        englishButton.backgroundColor = unselectedColor
        
        // Update color based on selection
        switch selectedLanguage {
        case "tr":
            turkishButton.backgroundColor = selectedColor
        case "en":
            englishButton.backgroundColor = selectedColor
        default:
            break
        }
    }
    
    private func getCurrentSelectedLanguage() -> String? {
        if turkishButton.backgroundColor == UIColor(hex: "F5BE0B") {
            return "tr"
        } else if englishButton.backgroundColor == UIColor(hex: "F5BE0B") {
            return "en"
        }
        return nil
    }
    
    private func loadLanguage() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            updateButtonColorForLanguage(selectedLanguage: savedLanguage)
        }
    }
    
    
    
}
