//  OnboardPasswordView.swift
//  inubriated
//
//  Created by David Holeman on 6/2/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct OnboardPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var globalVariables = GlobalVariables()
    @EnvironmentObject var userSettings: UserSettings
    
    @EnvironmentObject var viewRouteConrollerOnboard: ViewRouteControllerOnboard
    
    @State var passwordEntry: String = ""
    @State var passwordVerify: String = ""
    
    @State var isPasswordVisible: Bool = false
    
    @State var isPasswordStrengthValue: Int = 0
    @State var isPasswordStrengthLabel: String = "(enter)"
    @State var isPasswordStrengthImage: String = "imgStrengthOff"
    
    @State var isPasswordVerified: Bool = false
    @State var isPasswordVerifiedImage: String = "imgVerifyOff"
    
    /// An entry to correspond to each field tag for sequenced entry.  Set the field to true if you want it to become first responder
    @State var fieldFocus = [true, false]
    @State var isHidePassword = true
    
    var body: some View {
        HStack {
            Spacer().frame(width: 16)
            
            VStack(alignment: .leading) {
                Group {
                    Spacer().frame(height: 50)
                    HStack {
                        Button(action: {
                            viewRouteConrollerOnboard.currentPageView = .onboardEmailView  // go back a page
                        }
                        ) {
                            HStack {
                                btnPreviousView()
                            }
                        }
                        Spacer()
                    } // end HStack
                    .padding(.bottom, 16)
                    
                    Text("Password")
                        .font(.system(size: 24))
                        .fontWeight(.regular)
                        .padding(.bottom, 16)
                    Text("Please enter a password. You can change the password any time in settings.")
                        .font(.system(size: 16))
                } // end group
                
                Spacer().frame(height: 30)

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
                    Spacer().frame(height: 32)
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
                                } else {
                                    isPasswordVerified = false
                                    isPasswordVerifiedImage = "imgVerifyOff"
                                    }
                                })
                        Image(isPasswordVerifiedImage)
                            .imageScale(.large)
                            .frame(width: 32, height: 32, alignment: .center)
                    }
                } // end group
                
                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        // save values
                        // 1. email
                        UserDefaults.standard.setValue(userSettings.email, forKey: "username")
                        UserDefaults.standard.set(true, forKey: "hasLoginKey")

                        // 2. password
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
                        viewRouteConrollerOnboard.currentPageView = .onboardCompleteView

                    }) {
                        Text("Next")
                            .font(.system(size: 17))
                            .foregroundColor(isPasswordVerified ? .blue : .gray)
                        Image(systemName: "arrow.right")
                            .resizable()
                            .foregroundColor(isPasswordVerified ? .white : .white)
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(isPasswordVerified ? Color("btnNextOnboarding") : Color(UIColor.systemGray5))
                            .cornerRadius(30)
                    }
                    .disabled(isPasswordVerified ? false : true)
                }  // end HStack
                
                Spacer().frame(height: 30)
            } // end VStack
            Spacer().frame(width: 16)
        } // end HStack
        .background(Color("viewBackgroundColorOnboarding"))
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        .onTapGesture { self.hideKeyboard() }
        
    } // end view
} // end struc_


struct OnboardPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardPasswordView()
            .environmentObject(ViewRouteControllerOnboard())
            .environmentObject(UserSettings())
    }
}

