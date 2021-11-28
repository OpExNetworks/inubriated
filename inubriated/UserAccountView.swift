//  UserAccountView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct UserAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userSettings: UserSettings
    
    @State var firstname: String = UserSettings.init().firstname
    @State var lastname: String = UserSettings.init().lastname
    @State var email: String = UserSettings.init().email
    @State var phoneCell: String = UserSettings.init().phoneCell
    
    /// An entry to correspond to each field tag for sequenced entry
    @State var fieldFocus = [false, false]
    
    /// Phone number verification
    @State var isPhoneVerified: Bool = false
    @State var isPhoneVerifiedImage: String = "imgVerifyOff"
    @State var phoneNumber: String = ""
    @State var inputFormatMask = "+n (nnn) nnn-nnnn"

    /// email verification
    @State var isEmailVerified: Bool = false
    @State var isEmailVerifiedImage: String = "imgVerifyOff"
    
    /// Retrieve password
    @State var passwordPrevious: String = ""

    @State var isChanged: Bool = false
    
    @State var isTermsAccepted: Bool = false
    @State var isLicenseReviewed: Bool = false
    @State var isPrivacyReviewed: Bool = false
    
    var body: some View {
        
        NavigationView {
            HStack {

                VStack() {
                    Spacer().frame(height: 16)
                    
                    /* start stuff within our area */
                    
                    Form {
                        
                        VStack(alignment: .leading) {
                            Text("Account Settings!")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.bottom, 1)
                            Text("These are settings that define your account")
                                .font(.system(size: 14))
                        }
                        .frame(width: AppValue.screen.width - 36, height: 120, alignment: .leading)
                        .modifier(FrameCornerModifier())
                        .padding(.bottom, 16)
                        
                        Section(header: Text("name").offset(x: -16)) {
                            TextFieldEx (
                                label: "First name",
                                text: $firstname,
                                focusable: $fieldFocus,
                                returnKeyType: .next,
                                autocapitalizationType: .words,
                                textContentType: UITextContentType.givenName,
                                tag: 0
                            )
                            .onChange(of: firstname, perform: { value in
                                if value != userSettings.firstname { isChanged = true}
                            })
                            .offset(x: -16)
                            
                            TextFieldEx (
                                label: "Last name",
                                text: $lastname,
                                focusable: $fieldFocus,
                                returnKeyType: .done,
                                autocapitalizationType: .words,
                                textContentType: UITextContentType.familyName,
                                tag: 1
                            )
                            .onChange(of: lastname, perform: { value in
                                if value != userSettings.lastname { isChanged = true}
                            })
                            .offset(x: -16)
                        }
                        .offset(x: 16)
                        
                        Section(header: Text("email").offset(x: -16)) {
                            //TextField("Email Address", text: $email).offset(x: -20)
                            
                            HStack {
                                TextField(
                                    "Email address",
                                    text: $email,
                                    onEditingChanged: {(editingChanged) in
                                        if editingChanged {
                                            // check validity
                                            if isValidEmail(string: email) {
                                                isEmailVerified = true
                                            } else {
                                                isEmailVerified = false
                                                }
                                            
                                        } else {
                                            //if email == "+1 (" {email = ""} // or "+011" or whatever precursor
                                            }
                                        }
                                    )
                                    .offset(x: -16)
                                    .keyboardType(.emailAddress)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .textCase(.lowercase)
                                    .textContentType(.emailAddress)
                                    .onAppear {
                                        //email = userSettings.email
                                        
                                        // check validity
                                        if isValidEmail(string: email) {
                                            isEmailVerified = true
                                        } else {
                                            isEmailVerified = false
                                            }
                                    }
                                    .onChange(of: email, perform: { value in
                                        // check validity
                                        if isValidEmail(string: value) {
                                            isEmailVerified = true
                                        } else {
                                            isEmailVerified = false
                                            }
                                        
                                        if email != userSettings.email { isChanged = true }
                                        })
                                Image(isEmailVerifiedImage)
                                    .imageScale(.large)
                                    .frame(width: 32, height: 32, alignment: .center)
                                    .onChange(of: email, perform: { value in
                                        isEmailVerified = isValidEmail(string: value)
                                        if isEmailVerified {isEmailVerifiedImage = "imgVerifyOn" } else { isEmailVerifiedImage = "imgVerifyOff" }
                                    })
                                    .onChange(of: isEmailVerified, perform: { value in
                                        if value {isEmailVerifiedImage = "imgVerifyOn"} else {isEmailVerifiedImage = "imgVerifyOff"}
                                    })
                            }
                            
                        }
                        .offset(x: 16)
                        
                        Section(header: Text("phone").offset(x: -16)) {
                            HStack {
                                TextField(
                                    inputFormatMask,
                                    text: $phoneCell,
                                    onEditingChanged: {(editingChanged) in
                                        if phoneCell == "" { phoneCell = "+1 (" }
                                        if editingChanged {
                                            //get focus
                                        } else {
                                            //lose focus
                                        }
                                    })
                                    .offset(x: -16)
                                    .keyboardType(.phonePad)
                                    .textContentType(.telephoneNumber)
                                    .onAppear {
                                        phoneCell = userSettings.phoneCell
                                        phoneCell = formattedNumber(number: phoneCell, mask: inputFormatMask, char: "n")
                                        // check validity
                                        if isValidPhoneNumber(testStr: phoneCell) {
                                            isPhoneVerified = true
                                        } else {
                                            isPhoneVerified = false
                                            }
                                    }
                                    .onChange(of: phoneCell, perform: { value in
                                        // show formatted number on screen
                                        phoneCell = formattedNumber(number: value, mask: inputFormatMask, char: "n")
                                        // convert back to just number
                                        phoneNumber = unformattedNumber(number: value)
                                        // check validity
                                        if isValidPhoneNumber(testStr: value) {
                                            isPhoneVerified = true
                                        } else {
                                            isPhoneVerified = false
                                            }
                                        if phoneCell != userSettings.phoneCell { isChanged = true }
                                        })
                                Image(isPhoneVerifiedImage)
                                    .imageScale(.large)
                                    .frame(width: 32, height: 32, alignment: .center)
                                    .onChange(of: phoneCell, perform: { value in
                                        isPhoneVerified = isValidPhoneNumber(testStr: value)
                                        if isPhoneVerified {isPhoneVerifiedImage = "imgVerifyOn" } else { isPhoneVerifiedImage = "imgVerifyOff" }
                                    })
                                    .onChange(of: isPhoneVerified, perform: { value in
                                        if isPhoneVerified {isPhoneVerifiedImage = "imgVerifyOn" } else { isPhoneVerifiedImage = "imgVerifyOff" }
                                    })
                            }
                        }
                        .offset(x: 16)
                        
                        // Legal stuff
                        Section(header: Text("Legal").offset(x: -16)) {
                            NavigationLink(
                                destination: WebPageView(title: "Privacy Agreement",
                                subtitle: "Review the Privacy Agreement.",
                                webURL: AppValue.privacyURL,
                                isReviewed: $isPrivacyReviewed)
                                    .onAppear {
                                        isPrivacyReviewed = userSettings.isPrivacy
                                    }
                                    .onChange(of: isPrivacyReviewed, perform: { value in
                                        userSettings.isPrivacy = isPrivacyReviewed
                                    })
                            ) {
                                HStack {
                                    Text("Privacy Agreement").offset(x: -16)
                                }
                            }
                            
                            NavigationLink(
                                destination: WebPageView(title: "License Agreement",
                                subtitle: "Review the License Agreement.",
                                webURL: AppValue.licenseURL,
                                isReviewed: $isLicenseReviewed)
                                    .onAppear {
                                        isLicenseReviewed = userSettings.isLicensed
                                    }
                                    .onChange(of: isLicenseReviewed, perform: { value in
                                        userSettings.isLicensed = isLicenseReviewed
                                    })
                            ) {
                                HStack {
                                    Text("License Agreement").offset(x: -16)
                                }
                            }
                            
                            NavigationLink(
                                destination: AcceptDocView(title: "Terms & Conditions",
                                subtitle: "Review the Terms & Conditions Statement.",
                                content: termsData.content,
                                isAccepted: $isTermsAccepted
                                )
                                .onAppear {
                                    /// pass to
                                    isTermsAccepted = userSettings.isTerms
                                }
                                .onChange(of: isTermsAccepted, perform: { value in
                                    /// receive from
                                    userSettings.isTerms = isTermsAccepted
                                    if isTermsAccepted == false {
                                        print("ACTION: user declined terms")
                                        userSettings.isTerms = false
                                        /// TODO:  bail here if the user declines.   confirm they want to bail?  An alert pop up maybe
                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                            NotificationCenter.default.post(name: Notification.Name("isReset"), object: nil)
                                        }
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                })
                            
                            ) {
                                HStack {
                                    Text("Terms & Conditions").offset(x: -16)
                                }
                            }
                        }
                        .offset(x: 16)
                        .padding(.trailing, 8)
                        // end Legal Section

                    }

                    /* end stuff within our area */
                    Spacer()
                    Spacer().frame(height: 30)  // This gap puts some separate between the keyboard and the scrolled field
                }
                .background(Color(UIColor.systemGroupedBackground))
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Account")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("btnCancel")
                                .imageScale(.large)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if firstname != userSettings.firstname { userSettings.firstname = firstname.trimmingCharacters(in: .whitespacesAndNewlines) }
                            if lastname != userSettings.lastname { userSettings.lastname = lastname.trimmingCharacters(in: .whitespacesAndNewlines) }
                            
                            /// Save if  number is changed, is valid and is not blank
                            if phoneNumber != userSettings.phoneCell && isPhoneVerified { userSettings.phoneCell = phoneNumber }
                            
                            /// Save if blank
                            if phoneNumber == "" { userSettings.phoneCell = ""}
                            
//                            if phoneNumber != userSettings.phoneCell {
//                                if isValidPhoneNumber(testStr: phoneNumber) {
//                                    userSettings.phoneCell = phoneNumber
//
//                                } else {
//                                    userSettings.phoneCell = "" }
//                            }
                            
                            if email != userSettings.email && isEmailVerified {
                                /// Save username which is email and the password we retrieved onAppear and save here again so it's associated with the new email address in the keychain
                                
                                // 1. retrieve old password
                                do {
                                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                                            account: userSettings.username,
                                                                            accessGroup: KeychainConfiguration.accessGroup)
                                    let keychainPassword = try passwordItem.readPassword()
                                    passwordPrevious = keychainPassword
                                }
                                catch {
                                    passwordPrevious = ""
                                    fatalError("Error reading password from keychain - \(error)")
                                }
                                print("previous:", userSettings.email, passwordPrevious)
                                
                                // 2. save email
                                userSettings.email = email
                                UserDefaults.standard.setValue(email, forKey: "username")  //TODO:  Verify that changing email here changes it on login
                                UserDefaults.standard.set(true, forKey: "hasLoginKey")

                                // 3. save password
                                do {

                                    // This is a new account, create a new keychain item with the account name.
                                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                                            account: userSettings.email,
                                                                            accessGroup: KeychainConfiguration.accessGroup)

                                    // Save the password for the new item.
                                    try passwordItem.savePassword(passwordPrevious)
                                } catch {
                                    fatalError("Error updating keychain - \(error)")
                                }
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text(isChanged ? "Save" : "Done")
                        }
                    }
            })
                //Color.blue.frame(width: 8)
            }
            
        }
        .onAppear {
            /// load up when the view appears so that if you make a change and come back while still in the setting menu the values are current.
            firstname = userSettings.firstname
            lastname = userSettings.lastname
            email = userSettings.email
            phoneCell = userSettings.phoneCell
            isChanged = false
            print("UserSettings.init().phoneCell:", UserSettings.init().phoneCell)
            print("userSettings.phoneCell:", userSettings.phoneCell)
            print("phoneNumber:",phoneNumber)
        }
    }
}
    struct UserAccountView_Previews: PreviewProvider {
        static var previews: some View {
            UserAccountView()
                .environmentObject(UserSettings())
        }
    }



