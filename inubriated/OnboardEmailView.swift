//  OnboardEmailView.swift
//  inubriated
//
//  Created by David Holeman on 6/2/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct OnboardEmailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var globalVariables = GlobalVariables()
    @EnvironmentObject var userSettings: UserSettings
    
    @EnvironmentObject var viewRouteControllerOnboard: ViewRouteControllerOnboard
    
    @State var email: String = UserSettings.init().email
    
    /// An entry to correspond to each field tag for sequenced entry.  Set the field to true if you want it to become first responder
    @State var fieldFocus = [true]
    
    /// email verification
    @State var isEmailVerified: Bool = false
    @State var isEmailVerifiedImage: String = "imgVerifyOff"
    
//    init(){
//        UITableView.appearance().backgroundColor = .clear
//    }
    
    var body: some View {
        HStack {
            
            Spacer().frame(width: 16)
            
            VStack(alignment: .leading) {
                
                Group {
                    Spacer().frame(height: 50)
                    HStack {
                        Button(action: {
                            viewRouteControllerOnboard.currentPageView = .onboardAccountView  // go back a page
                        }
                        ) {
                            HStack {
                                btnPreviousView()
                            }
                        }
                        Spacer()
                    } // end HStack
                    .padding(.bottom, 16)
                    
                    Text("Email")
                        .font(.system(size: 24))
                        .fontWeight(.regular)
                        .padding(.bottom, 16)
                    Text("Your email address is used to as your account ID.")
                        .font(.system(size: 16))
                }

                Spacer().frame(height: 30)
                
                Group {
                    Text("EMAIL ADDRESS")
                        .font(.caption)
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
                            tag: 0
                        )
                        .frame(height: 40)
                        .padding(.vertical, 0)
                        .overlay(Rectangle().frame(height: 0.5).padding(.top, 30))
                            .onAppear {
                                //email = myUserAccount.email

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
                        
                    } // end HStack
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        if email != userSettings.email && isEmailVerified {
                           userSettings.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                        viewRouteControllerOnboard.currentPageView = .onboardPasswordView
                    }
                    ) {
                        HStack {
                            Text("next")
                                .foregroundColor(isEmailVerified ? .blue : .gray)
                            Image(systemName: "arrow.right")
                                .resizable()
                                .foregroundColor(isEmailVerified ? .white : .white)
                                .frame(width: 30, height: 30)
                                .padding()
                                .background(isEmailVerified ? Color("btnNextOnboarding") : Color(UIColor.systemGray5))
                                .cornerRadius(30)
                        }
                    }
                    .disabled(isEmailVerified ? false : true)
                } // end HStack
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


struct OnboardEmailView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardEmailView()
            .environmentObject(ViewRouteControllerOnboard())
            .environmentObject(UserSettings())
    }
}

