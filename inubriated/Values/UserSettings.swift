//  UserSettings.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  
//

import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
            printSave(forKey: "username", value: username)
        }
    }
    @Published var isOnboarded: Bool {
        didSet {
            UserDefaults.standard.set(isOnboarded, forKey: "isOnboarded")
            printSave(forKey: "isOnboarded", value: isOnboarded)
        }
    }
    @Published var isTerms: Bool {
        didSet {
            UserDefaults.standard.set(isTerms, forKey: "isTerms")
            printSave(forKey: "isTerms", value: isTerms)
        }
    }
    @Published var isWelcomed: Bool {
        didSet {
            UserDefaults.standard.set(isWelcomed, forKey: "isWelcomed")
            printSave(forKey: "isWelcomed", value: isWelcomed)
        }
    }
    @Published var isAccount: Bool {
        didSet {
            UserDefaults.standard.set(isAccount, forKey: "isAccount")
            printSave(forKey: "isAccount", value: isAccount)
        }
    }
    @Published var isPrivacy: Bool {
        didSet {
            UserDefaults.standard.set(isPrivacy, forKey: "isPrivacy")
            printSave(forKey: "isPrivacy", value: isPrivacy)
        }
    }
    @Published var isLicensed: Bool {
        didSet {
            UserDefaults.standard.set(isLicensed, forKey: "isLicensed")
            printSave(forKey: "isLicensed", value: isLicensed)
        }
    }

    @Published var isAutoLogin: Bool {
        didSet {
            UserDefaults.standard.set(isAutoLogin, forKey: "isAutoLogin")
            printSave(forKey: "isAutoLogin", value: isAutoLogin)
        }
    }
    @Published var isBiometricID: Bool {
        didSet {
            UserDefaults.standard.set(isBiometricID, forKey: "isBiometricID")
            printSave(forKey: "isBiometricID", value: isBiometricID)
        }
    }
    
    @Published var landingPage: String {
        didSet {
            UserDefaults.standard.set(landingPage, forKey: "landingPage")
            printSave(forKey: "landingPage", value: landingPage)
        }
    }
    @Published var pinnedUnicode: String {
        didSet {
            UserDefaults.standard.set(pinnedUnicode, forKey: "pinnedUnicode")
            printSave(forKey: "pinnedUnicode", value: pinnedUnicode)
        }
    }
    
    @Published var isFaqExpanded: Bool {
        didSet {
            UserDefaults.standard.set(isFaqExpanded, forKey: "isFaqExpanded")
            printSave(forKey: "isFaqExpanded", value: isFaqExpanded)
        }
    }

    
    @Published var avatar: UIImage {
        didSet {
            /// Convert to data using .pngData() on the image so it will store.  It won't take the UIImage straight up.
            let pngRepresentation = avatar.pngData()
            UserDefaults.standard.set(pngRepresentation, forKey: "avatar")
            printSave(forKey: "avatar", value: avatar)
        }
    }
    @Published var alias: String {
        didSet {
            UserDefaults.standard.set(alias, forKey: "alias")
            printSave(forKey: "alias", value: alias)
        }
    }
    @Published var birthday: Date {
        didSet {
            UserDefaults.standard.set(birthday, forKey: "birthday")
            printSave(forKey: "birthday", value: birthday)
        }
    }
    
    @Published var email: String {
        didSet {
            UserDefaults.standard.set(email, forKey: "email")
            printSave(forKey: "email", value: email)
        }
    }
    
    @Published var firstname: String {
        didSet {
            UserDefaults.standard.set(firstname, forKey: "firstname")
            printSave(forKey: "firstname", value: firstname)
        }
    }
    @Published var lastname: String {
        didSet {
            UserDefaults.standard.set(lastname, forKey: "lastname")
            printSave(forKey: "lastname", value: lastname)
        }
    }
    @Published var phoneCell: String {
        didSet {
            UserDefaults.standard.set(phoneCell, forKey: "phoneCell")
            printSave(forKey: "phoneCell", value: phoneCell)
        }
    }
    
    init() {
        self.username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
        self.isOnboarded = UserDefaults.standard.object(forKey: "isOnboarded") as? Bool ?? false
        self.isTerms = UserDefaults.standard.object(forKey: "isTerms") as? Bool ?? false
        self.isWelcomed = UserDefaults.standard.object(forKey: "isWelcomed") as? Bool ?? false
        self.isAccount = UserDefaults.standard.object(forKey: "isAccount") as? Bool ?? false
        self.isPrivacy = UserDefaults.standard.object(forKey: "isPrivacy") as? Bool ?? false
        self.isLicensed = UserDefaults.standard.object(forKey: "isLicensed") as? Bool ?? false
        
        self.isAutoLogin = UserDefaults.standard.object(forKey: "isAutoLogin") as? Bool ?? false
        self.isBiometricID = UserDefaults.standard.object(forKey: "isBiometricID") as? Bool ?? false
        
        
        self.landingPage = UserDefaults.standard.object(forKey: "landingPage") as? String ?? AppValue.landingPage
        self.pinnedUnicode = UserDefaults.standard.object(forKey: "pinnedUnicode") as? String ?? AppValue.pinnedUnicode
        self.isFaqExpanded = UserDefaults.standard.object(forKey: "isFaqExpanded") as? Bool ?? false

        self.avatar = UIImage(data: UserDefaults.standard.object(forKey: "avatar") as? Data ?? AppDefault.avatar.pngData()!) ?? AppDefault.avatar

        
        self.alias = UserDefaults.standard.object(forKey: "alias") as? String ?? ""
        self.birthday = UserDefaults.standard.object(forKey: "birthday") as? Date ?? DateInfo.zeroDate
        
        self.email = UserDefaults.standard.object(forKey: "email") as? String ?? ""
        
        self.firstname = UserDefaults.standard.object(forKey: "firstname") as? String ?? ""
        self.lastname = UserDefaults.standard.object(forKey: "lastname") as? String ?? ""
        self.phoneCell = UserDefaults.standard.object(forKey: "phoneCell") as? String ?? ""
    }
    
    private func printSave(forKey: String, value: Any) {
        print("Saving: \(forKey) = \(value)")
    }
}

