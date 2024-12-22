//
//  ProfileModel.swift
//  Wazaaaaap
//
//  Created by Imac on 21.12.24.
//

import Foundation

struct ProfileModel {
    var fullName: String
    var username: String
    var selectedLanguage: Language
    
    enum Language: String {
        case georgian = "ქართული"
        case english = "English"
    }
}
