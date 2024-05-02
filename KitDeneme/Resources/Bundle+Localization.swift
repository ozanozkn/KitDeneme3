//
//  Bundle+Localization.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 2.05.2024.
//
import Foundation

extension Bundle {
    static func swizzleLocalizationBundle(_ bundle: Bundle) {
        object_setClass(Bundle.main, type(of: bundle))
    }
    
    class func setLanguage(_ languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
    }
}


