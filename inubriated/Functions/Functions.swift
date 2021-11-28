//  Functions.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI


func printUserSettings(description: String) {
    
    print(description + ":")
    //print("isAccount ---->", "")
    print("isAutoLogin --->", UserDefaults.standard.object(forKey: "isAutoLogin") as? Bool ?? false)
    print("isBiometricID ->", UserDefaults.standard.object(forKey: "isBiometricID") as? Bool ?? false)

    print("isOnboarded --->", UserDefaults.standard.object(forKey: "isOnboarded") as? Bool ?? false)
    print("isTerms ------->", UserDefaults.standard.object(forKey: "isTerms") as? Bool ?? false)
    print("isWelcomed ---->", UserDefaults.standard.object(forKey: "isWelcomed") as? Bool ?? false)
    print("isPrivacy ----->", UserDefaults.standard.object(forKey: "isPrivacy") as? Bool ?? false)
    print("isLicense ----->", UserDefaults.standard.object(forKey: "isLicensed") as? Bool ?? false)

    print("landingPage --->", UserDefaults.standard.object(forKey: "landingPage") as? String ?? AppValue.landingPage)
    print("pinnedUnicode ->", UserDefaults.standard.object(forKey: "pinnedUnicode") as? String ?? AppValue.pinnedUnicode)
    print("isFaqExpanded ->", UserDefaults.standard.object(forKey: "isFaqExpanded") as? Bool ?? false)
    
    print("phoneCell ----->", UserDefaults.standard.object(forKey: "phoneCell") as? String ?? "")

    //print("isLoggedIn --->", SessionStatus.isLoggedIn)
}

// MARK: Format date into MM/DD/yyyy format
func formatDate(date: Date) -> String {
    let formatter = DateFormatter()
    //formatter.dateStyle = .short
    formatter.dateFormat = "MM/DD/yyyy"
    return formatter.string(from: date)
}

// MARK: Validate phone number as it's being entered.
func isValidPhoneNumber(testStr:String) -> Bool {
    let phoneRegEx = "\\+[1{1}]\\s\\(\\d{3}\\)\\s\\d{3}-\\d{4}$"
    let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
    return phoneTest.evaluate(with: testStr)
}

// MARK: Format the number to the mask
func formattedNumber(number: String, mask: String, char: Character) -> String {
    let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    var result = ""
    var index = cleanPhoneNumber.startIndex
    for ch in mask {
        if index == cleanPhoneNumber.endIndex {
            break
        }
        if ch == char {
            result.append(cleanPhoneNumber[index])
            index = cleanPhoneNumber.index(after: index)
        } else {
            result.append(ch)
        }
    }
    return result
}
// MARK:  Return unformatted phone number.  Just the digits.
func unformattedNumber(number: String) -> String {
    return number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
}

//  MARK: Validate email email format.
func isValidEmail(string:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: string)
}

// MARK: Convert landing page string to an index value and back
func myLandingPageIndex(string: String) -> Int {
    var value: Int = 0
    for (index, str) in AppValue.landingPageOptions.enumerated() {
        if str == string { value = index ; break }
    }
   return value
}
func myLandingPageName(index: Int) -> String {
    return AppValue.landingPageOptions[index]
}

// MARK: Convert pinned symbol to an index value and back
func myPinnedSymbolIndex(string: String) -> Int {
    var value: Int = 0
    for (index, str) in AppValue.pinnedUnicodeOptions.enumerated() {
        if str == string { value = index ; break }
    }
   return value
}
func myPinnedSymbolName(index: Int) -> String {
    return AppValue.pinnedUnicodeOptions[index]
}

// MARK: Check to see that while an image may exist does it have anything inside
// Used with the AvatarPickerView() to see if an actual image for the avatar has been selected
func isImageEmpty(_ image: UIImage) -> Bool {
    guard let cgImage = image.cgImage,
          let dataProvider = cgImage.dataProvider else
    {
        return true
    }

    let pixelData = dataProvider.data
    let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
    let imageWidth = Int(image.size.width)
    let imageHeight = Int(image.size.height)
    for x in 0..<imageWidth {
        for y in 0..<imageHeight {
            let pixelIndex = ((imageWidth * y) + x) * 4
            let r = data[pixelIndex]
            let g = data[pixelIndex + 1]
            let b = data[pixelIndex + 2]
            let a = data[pixelIndex + 3]
            if a != 0 {
                if r != 0 || g != 0 || b != 0 {
                    return false
                }
            }
        }
    }

    return true
}
