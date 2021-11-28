//  UserSecurityReview.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct UserSecurityView: View {
    
    let myDevice = BiometricAuthType()
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var globalVariables: GlobalVariables
    @EnvironmentObject var userSettings: UserSettings
   
    @State var isAutoLogin: Bool = UserSettings.init().isAutoLogin
    @State var isBiometricID: Bool = UserSettings.init().isBiometricID
    
    @State var passwordEntry: String = ""
    @State var passwordVerify: String = ""
    @State var passwordLast: String = ""
    
    @State var isPasswordVisible: Bool = false
    
    @State var isPasswordStrengthValue: Int = 0
    @State var isPasswordStrengthLabel: String = "(enter)"
    @State var isPasswordStrengthImage: String = "imgStrengthOff"
    
    @State var isPasswordVerified: Bool = false
    @State var isPasswordVerifiedImage: String = "imgVerifyOff"
    
    @State var isChanged: Bool = false
    
    /// An entry to correspond to each field tag for sequenced entry.  Set the field to true if you want it to become first responder
    @State var fieldFocus = [false, false]
    @State var isHidePassword = true
    
    var body: some View {
        
//        NavigationView {
            HStack {
                VStack() {
                    Spacer().frame(height: 16)
                    Form {

                        /* start stuff within our area */
                        VStack(alignment: .leading) {
                            Text("Security Settings!")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.bottom, 1)
                            Text("Secure access to your app...")
                                .font(.system(size: 14))

                        }
                        .frame(width: AppValue.screen.width - 36, height: 120, alignment: .leading)
                        .modifier(FrameCornerModifier())
                        .padding(.bottom, 16)

                        /* */
                        Section(header: Text("Login Settings").offset(x: -16)) {
                            Toggle(isOn: self.$isAutoLogin) {
                                Text("Auto Login").offset(x: -16)
                            }
                            .onChange(of: isAutoLogin, perform: { value in
                                userSettings.isAutoLogin = value
                                isChanged = true
                            })
                            .onAppear {
                                isAutoLogin = userSettings.isAutoLogin
                            }
                            .padding(.trailing, 8)
                            
                            Toggle(isOn: self.$isBiometricID) {
                                Text("Biometric ID").offset(x: -16)
                            }
                            .onChange(of: isBiometricID, perform: { value in
                                userSettings.isBiometricID = value
                                isChanged = true
                            })
                            .onAppear {
                                isBiometricID = userSettings.isBiometricID
                            }
                            .disabled(myDevice.canEvaluatePolicy() == false)
                            .padding(.trailing, 8)
                        }
                        .offset(x: 16)
                        
                        Section(header: Text("Reset Password").offset(x: -16)) {
                            Group {
                                HStack {
                                    Text("PASSWORD \(isPasswordStrengthLabel)")
                                        .onChange(of: passwordEntry, perform: { value in
                                            // check strength
                                            let strength = passwordStrengthCheck(string: passwordEntry)
                                            isPasswordStrengthLabel = strength.label
                                        })
                                        .font(.caption)
                                    Spacer()
                                    Button(action: {
                                        isHidePassword.toggle()
                                    }) {
                                        Text(isHidePassword ? "Show" : "Hide")
                                            .font(.caption)
                                    }
                                    
                                }
                                HStack {
                                    //SecureField("Enter password", text: $passwordEntry)
                                    TextFieldEx (
                                        label: "password",
                                        text: $passwordEntry,
                                        focusable: $fieldFocus,
                                        isSecureTextEntry: $isHidePassword,
                                        returnKeyType: .next,
                                        autocorrectionType: .no,
                                        tag: 0
                                    )
                                    .frame(height: 40)
                                    .padding(.vertical, 0)
                                    .overlay(Rectangle().frame(height: 0.5).padding(.top, 30))
                                    .onChange(of: passwordEntry, perform: { value in
                                        // check strength
                                        let strength = passwordStrengthCheck(string: passwordEntry)
                                        isPasswordStrengthImage = strength.image
                                        if strength.value == 0 {isPasswordVerified = false}
                                    })
                                    Image(isPasswordStrengthImage)
                                        .imageScale(.large)
                                        .frame(width: 32, height: 32, alignment: .center)
                                }

                                HStack {
                                    //SecureField("Verify Password", text: $passwordVerify)
                                    TextFieldEx (
                                        label: "verify password",
                                        text: $passwordVerify,
                                        focusable: $fieldFocus,
                                        isSecureTextEntry: $isHidePassword,
                                        returnKeyType: .done,
                                        autocorrectionType: .no,
                                        tag: 1
                                    )
                                    .frame(height: 40)
                                        .padding(.vertical, 0)
                                        .overlay(Rectangle().frame(height: 0.5).padding(.top, 30))
                                        //.foregroundColor(inputColor)
                                        .onChange(of: passwordVerify, perform: { value in
                                            // check validity
                                            if passwordVerify == passwordEntry && passwordStrengthCheck(string: passwordEntry).value > 0 {
                                                isPasswordVerified = true
                                                isPasswordVerifiedImage = "imgVerifyOn"
                                                if passwordVerify != passwordLast {isChanged = true}
                                            } else {
                                                isPasswordVerified = false
                                                isPasswordVerifiedImage = "imgVerifyOff"
                                                isChanged = false
                                                }
                                            isChanged = true
                                            }
                                        )
                                    Image(isPasswordVerifiedImage)
                                        .imageScale(.large)
                                        .frame(width: 32, height: 32, alignment: .center)
                                }
                            } // end group
                            .offset(x: -16)
                        }
                        .offset(x: 16)
                        /* */
                    }
                    Spacer()
                    Spacer().frame(height: 30)
                } // end VStack
                .background(Color(UIColor.systemGroupedBackground))
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Security")
//                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button(action: {
//                            self.presentationMode.wrappedValue.dismiss()
//                        }) {
//                            Image("btnCancel")
//                                .imageScale(.large)
//                        }
//                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if isPasswordVerified {
                                // save password
                                print("userSettings.email:",userSettings.email)
                                do {

                                    // This is a new account, create a new keychain item with the account name.
                                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                                            account: userSettings.email,
                                                                            accessGroup: KeychainConfiguration.accessGroup)

                                    // Save the password for the new item.
                                    try passwordItem.savePassword(passwordVerify)
                                    print("new password saved: '\(passwordVerify)'")

                                } catch {
                                    fatalError("Error updating keychain - \(error)")
                                }
                            }

                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text(isChanged ? "Save": "Done")
                        }
                    }
                })
            }
            //...
//        }
        .onAppear {
            /// load up when the view appears so that if you make a change and come back while still in the setting menu the values are current.
            isAutoLogin = userSettings.isAutoLogin
            isBiometricID = userSettings.isBiometricID
            isChanged = false
            
            do {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: userSettings.email,
                                                        accessGroup: KeychainConfiguration.accessGroup)
                let keychainPassword = try passwordItem.readPassword()
                passwordEntry = keychainPassword
                passwordVerify = keychainPassword
                passwordLast = keychainPassword     // retain so we can check for changes
            }
            catch {
                passwordEntry = ""
                passwordVerify = ""
                fatalError("Error reading password from keychain - \(error)")
            }

        }
    }
}

struct UserSecurityView_Previews: PreviewProvider {
    static var previews: some View {
        UserSecurityView()
            .environmentObject(GlobalVariables())
            .environmentObject(UserSettings())
    }
}


