//  ForgotPassword.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSettings: UserSettings
    
    @State var email: String = UserSettings.init().email
    
    /// An entry to correspond to each field tag for sequenced entry.  Set the field to true if you want it to become first responder
    @State var fieldFocus = [false]
    
    /// email verification
    @State var isEmailVerified: Bool = false
    @State var isEmailVerifiedImage: String = "imgVerifyOff"
    
    /// not really necessary but it works if you want to change the appearance of the NavBar
//    init(){
//        UINavigationBar.appearance().backgroundColor = UIColor(named: "viewBackgroundColorForgotPassword")
//    }
    
    var body: some View {
        NavigationView {
            HStack {
                Spacer().frame(width: 16)
                VStack(alignment: .leading) {
                    Spacer().frame(height: 60)
                    Text("We will send a password reset to the address below.")
                        .foregroundColor(Color("colorTextFixed"))
                    Spacer().frame(height: 30)
                    Group {
                        Text("EMAIL ADDRESS")
                            .font(.caption)
                            .foregroundColor(Color("colorTextFixed"))
                        HStack {
                            /// Email address
                            
                            TextFieldEx (
                                label: "email address",
                                text: $email,
                                focusable: $fieldFocus,
                                returnKeyType: .done,
                                autocapitalizationType: Optional.none,
                                keyboardType: .emailAddress,
                                textContentType: UITextContentType.emailAddress,
                                textColor: UIColor(Color("colorTextFixed")),
                                tag: 0
                            )
                            .frame(height: 40)
                            .padding(.vertical, 0)
                            .overlay(Rectangle().frame(height: 0.5).padding(.top, 30))
                                .onAppear {
                                    // check validity
                                    if isValidEmail(string: email) {
                                        isEmailVerified = true
                                    } else {
                                        isEmailVerified = false
                                        }
                                }
                                .onChange(of: email, perform: { value in
                                    // force lowercase
                                    email = email.lowercased()
                                    // check validity
                                    if isValidEmail(string: value) {
                                        isEmailVerified = true
                                    } else {
                                        isEmailVerified = false
                                        }
                                }).foregroundColor(Color("colorTextFixed"))
                            
                            
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
                            
                        } // end HStack
                    } // end Group)
                    Spacer().frame(height: 30)
                    HStack {
                        Spacer()
                        Button(action: {
                            /// Send request for password
                            print("send password reset")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        ) {
                            HStack {
                                Text("submit")
                                    .foregroundColor(isEmailVerified ? .white : .gray)
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .foregroundColor(isEmailVerified ? .white : .white)
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(isEmailVerified ? Color("btnNext") : Color(UIColor.systemGray5))
                                    .cornerRadius(30)
                            }
                        }
                        .disabled(isEmailVerified ? false : true)
                    } // end HStack
                    Spacer()
                } // end VStack
                Spacer().frame(width: 16)
            } // end HStack
            .background(GlobalThemes.viewBackgroundGradientForgotPassword)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Forgot Password")
            .navigationBarTitleDisplayMode(.inline)
            //.navigationBarColor(UIColor(named: "viewBackgroundColorForgotPassword"))
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
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
            })
        } // end NavigationView
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

