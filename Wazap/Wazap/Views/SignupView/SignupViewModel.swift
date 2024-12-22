//
//  SignupViewModel.swift
//  Wazap
//
//  Created by Nkhorbaladze on 22.12.24.
//

import SwiftUI

final class SignupViewModel: ObservableObject {    
    func validateFullName(_ fullname: String) -> Bool {
        let fullNameRegex = "^[A-Za-z\\s]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)
        return predicate.evaluate(with: fullname)
    }
    
    func validateUsername(_ username: String) -> Bool {
        let usernameRegex = "^[^\\s]{5,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return predicate.evaluate(with: username)
    }
    
    func validateEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: password)
    }
    
    func validateFields(fullName: String, userName: String, email: String, password: String, confirmPassword: String) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        if fullName.isEmpty {
            errors.append(.fullNameEmpty)
        } else if !validateFullName(fullName) {
            errors.append(.fullName)
        }
        
        if userName.isEmpty {
            errors.append(.usernameEmpty)
        } else if !validateUsername(userName) {
            errors.append(.username)
        }
        
        if email.isEmpty {
            errors.append(.emailEmpty)
        } else if !validateEmail(email) {
            errors.append(.email)
        }
        
        if password.isEmpty {
            errors.append(.passwordEmpty)
        } else if !validatePassword(password) {
            errors.append(.password)
        }
        
        if confirmPassword.isEmpty {
            errors.append(.confirmPasswordEmpty)
        } else if password != confirmPassword {
            errors.append(.confirmPassword)
        }
        
        return errors
    }
}

enum ValidationError: LocalizedError {
    case fullName
    case fullNameEmpty
    case username
    case usernameEmpty
    case email
    case emailEmpty
    case password
    case passwordEmpty
    case confirmPassword
    case confirmPasswordEmpty
    
    var errorDescription: String? {
        switch self {
        case .fullName:
            return "Full name can only contain letters and spaces."
        case .fullNameEmpty:
            return "Full name is required."
        case .username:
            return "Username must be at least 5 characters long and contain no spaces."
        case .usernameEmpty:
            return "Username is required."
        case .email:
            return "Enter a valid email address."
        case .emailEmpty:
            return "Email is required"
        case .password:
            return "Password must be 8+ characters, include uppercase, lowercase, a number, and a special character."
        case .passwordEmpty:
            return "Password is required"
        case .confirmPassword:
            return "Passwords don't match."
        case .confirmPasswordEmpty:
            return "Password confirmation is required."
        }
    }
}
