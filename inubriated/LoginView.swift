//  LoginView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct KeychainConfiguration {
    static let serviceName = AppValue.appName //"inubriated"
    static let accessGroup: String? = nil
}

struct LoginView: View {
    
    let myDevice = BiometricAuthType()
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var globalVariables = GlobalVariables()
    //@EnvironmentObject var globalVariables: GlobalVariables
    @EnvironmentObject var userSettings: UserSettings
    
    @State var username: String = ""
    @State var password: String = ""
    @State var isAutoLogin: Bool = UserSettings.init().isAutoLogin  //myUserSettings.isAutoLogin
    //@State var isBiometricID: Bool = UserSettings.init().isBiometricID
    
    @State var btnBiometricEnabled = false
    @State var btnBiometricImage = "faceid"
    
    var passwordItems: [KeychainPasswordItem] = []
    
    @State var showLoginFailedAlert: Bool = false
    
    @State var isLogoButton: Bool = false
    @State var isShowForgotPassword: Bool = false
    
    /// email verification
    @State var isEmailVerified: Bool = false
    @State var isEmailVerifiedImage: String = "imgVerifyOff"
    
    /// An entry to correspond to each field tag for sequenced entry.  Set the field to true if you want it to become first responder
    @State var fieldFocus = [false, false]
    @State var isHidePassword = true
    
    var body: some View {
        HStack() {
            Spacer().frame(width: 16)
            
            VStack(alignment: .leading) {
                
                Spacer().frame(height: 90)
                HStack {
                    Button(action: {
                        print("logo click")
                        isLogoButton.toggle()
                    }) {
                        Image(colorScheme == .dark ? AppValue.appLogoDarkMode : AppValue.appLogoWhite)
                            .resizable()
                            .frame(width: 124, height: 124, alignment: .center)
                    }
                    Spacer()
                    
                    VStack {
                        Text("Version: \(AppInfo.version) (\(AppInfo.build))")
                            .foregroundColor(isLogoButton ? .white : .clear)
                            .font(.footnote)
                        Spacer()
                    }
                }
                .frame(height: 124)

                Spacer().frame(height: 90)
                
                Group {
                    TextFieldEx (
                        label: "email address",
                        text: $username,
                        focusable: $fieldFocus,
                        returnKeyType: .next,
                        keyboardType: .emailAddress,
                        textColor: UIColor(Color("colorTextFixed")),
                        tag: 0
                    )
                    .frame(height: 40)
                    .padding(.vertical, 0)
                    .overlay(Rectangle().frame(height: 0.5).padding(.top, 30).foregroundColor(Color("colorTextFixed")))
                    .onChange(of: username, perform: { value in
                        // force lowercase
                        username = username.lowercased()
                        // check validity
                        if isValidEmail(string: value) {
                            isEmailVerified = true
                        } else {
                            isEmailVerified = false
                            }
                        })

                    TextFieldEx (
                        label: "password",
                        text: $password,
                        focusable: $fieldFocus,
                        isSecureTextEntry: $isHidePassword,
                        returnKeyType: .done,
                        autocorrectionType: .no,
                        textColor: UIColor(Color("colorTextFixed")),
                        tag: 1
                    )
                    .frame(height: 40)
                    .padding(.vertical, 0)
                    .overlay(Rectangle().frame(height: 0.5).padding(.top, 30).foregroundColor(Color("colorTextFixed")))
                    .foregroundColor(Color("colorTextFixed"))
                }  // end group
                
                HStack {
                    Spacer()
                    Button(action: {
                        isAutoLogin.toggle()
                        print("automatic login clicked")
                    }) {
                        VStack {
                            HStack {
                                Text("automatic login")
                                    .foregroundColor(Color("btnColorFixed"))
                                    .font(.system(size: 14, weight: .light, design: .default))
                                Image(systemName: isAutoLogin ? "checkmark.circle" : "circle")
                                    .foregroundColor(Color("btnColorFixed"))
                                    .font(.system(size: 24, weight: .light, design: .default))
                            }
                            Spacer()
                        }
                    }
                }
                .frame(height: 50)
                
                HStack {
                    /// Show button only if biometrics are enabled
                    if btnBiometricEnabled {
                        Button(action: {
                            authenticationWithTouchID()
                            userSettings.isBiometricID = true
                        } ) {
                            Image(systemName: btnBiometricImage)
                                .resizable()
                                .foregroundColor(Color("btnColorFixed"))
                                .font(Font.title.weight(.thin))
                                .frame(width: 60, height: 60, alignment: .center)
                        }
                    } else { Spacer().frame(width: 60, height: 60) }
                    
                    Spacer()

                    VStack {
                        Spacer()
                        Button(action: {
                            if username.isEmpty, password.isEmpty {
                                showLoginFailedAlert = true
                            }
                            if checkLogin(username: username, password: password) {
                                authenticated()
                            } else {
                                showLoginFailedAlert = true
                            }
                        }) { Text("Login")
                            .foregroundColor(Color("btnColorFixed"))
                            .font(.system(size: 24, weight: .medium, design: .default))
                        }
                        .alert(isPresented: $showLoginFailedAlert, content: {
                            showLoginFailedAlert = false  // reset
                            return Alert(title: Text("Login Problem"), message: Text("Wrong username or password"), dismissButton: .default(Text("Ok")) )
                    })
                    }
                }.frame(height: 60)
                
                Spacer()
                
                Button(action: {
                    isShowForgotPassword.toggle()
                }) {
                    Text("forgot password")
                        .foregroundColor(Color("btnColorFixed"))
                        .font(.system(size: 14, weight: .light, design: .default))
                }
                .sheet(isPresented: $isShowForgotPassword) {
                    ForgotPasswordView()
                }

                Spacer().frame(height: 60)
                
            } // end VStack
            
            Spacer().frame(width: 16)
        }
        .background(GlobalThemes.viewBackgroundGradientLogin)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {

            /// Bring up local stored username
            if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
                username = storedUsername
            }

            /// Evaluate biometric capabilities of the device
            if myDevice.isBiometric() == true {
                switch myDevice.biometricType() {
                case .faceID:
                    btnBiometricImage = "faceid"
                    btnBiometricEnabled = true
                case .touchID:
                    btnBiometricImage = "touchid"
                    btnBiometricEnabled = true
                default:
                    /// Biometric type didn't match allowed cases so disable
                    btnBiometricEnabled = false
                }
            } else {
                /// if we can't evaluate the biometric capability then disable
                btnBiometricEnabled = false
                userSettings.isBiometricID = false  // set back to false if the user has disabled.  Only option is for user to reinstall the app.
            }
            
            /**/
            // if auto login is true and logged in status is false then load the password text into the password field and get on with it
            if userSettings.isAutoLogin && globalVariables.isLoggedIn == false {
                print("isAutoLogin = true and isLoggedIn = false: ")
                do {
                    // This is a new account, create a new keychain item with the account name.
                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                            account: userSettings.email,
                                                            accessGroup: KeychainConfiguration.accessGroup)
                    
                    try self.password = passwordItem.readPassword()
                    
                } catch {
                    fatalError("Error updating keychain - \(error)")
                }
                authenticated()
            } else {
                
                // clear out password
                password = ""
            }

            /// Once biometric is enabled by the user via iOS and the isBiometricID is set by the app this will autologin via biometrics
            if globalVariables.isLoggedIn == false {

                // if the setting to allow biometric login is set then try to login using biometrics.
                if userSettings.isBiometricID &&  myDevice.isBiometric() == true { authenticationWithTouchID() }

            }
            
        } // end HStack
        .onTapGesture { self.hideKeyboard() }
        
    } // end view
    
    func authenticated() {
        print("^ User authenticated: Username:", userSettings.email, "  Password:", password)

        if userSettings.isAutoLogin != isAutoLogin { userSettings.isAutoLogin = isAutoLogin }
        
        // if biometrics are enabled then set to true on the settings
        //if btnBiometricEnabled && userSettings.isBiometricID == false {userSettings.isBiometricID = true}
        
        /// Let the user in via the Receiver in the MainView()
        //globalVariables.isLoggedIn = true
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            NotificationCenter.default.post(name: Notification.Name("isLoggedIn"), object: nil)
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func checkLogin(username: String, password: String) -> Bool {
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
        }
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        }
        catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }
    
} // end struc_


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(GlobalVariables())
            .environmentObject(UserSettings())
    }
}

