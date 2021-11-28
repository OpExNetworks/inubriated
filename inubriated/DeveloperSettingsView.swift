//  DeveloperSettingsView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI
import CoreData

struct DeveloperSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var globalVariables: GlobalVariables
    @EnvironmentObject var userSettings: UserSettings
    
    @State var mySettingsContent: String = AppValue.displaySettings

    @State var isOnboarded: Bool = false
    @State var isTerms: Bool = false
    @State var isWelcomed: Bool = false
    @State var isAccount: Bool = false
    @State var isPrivacy: Bool = false
    @State var isLicensed: Bool = false
    
    @State var showAlert: Bool = false
    @State var showAlertError: Bool = false
    
    var body: some View {
        
        NavigationView {
            HStack {
                VStack() {
                    Spacer().frame(height: 16)
                    
                    /* start stuff within our area */

                    Form {
                        VStack(alignment: .leading) {
                            Text("Developer Settings!")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.bottom, 1)
                            Text("These settings control the behavior of the app...")
                                .font(.system(size: 14))
                        }
                        .frame(width: AppValue.screen.width - 36, height: 120, alignment: .leading)
                        .modifier(FrameCornerModifier())
                        .padding(.bottom, 16)
                        
                        // TODO:  as they save on change vs. save on exit.  have to change the onChange to note a @state value then check the state values on save exit
                        
                        /// App Settings
                        
                        Section(header: Text("APP Settings").offset(x: -16)) {
                            
                            Toggle(isOn: self.$isOnboarded) {
                                Text("Onboarded").offset(x: -16)
                            }
                            .onAppear {
                                isOnboarded = userSettings.isOnboarded
                            }
                            .padding(.trailing, 8)
                            
                            Toggle(isOn: self.$isTerms) {
                                Text("Terms").offset(x: -16)
                            }
                            .onAppear {
                                isTerms = userSettings.isTerms
                            }
                            .padding(.trailing, 8)
         
                            Toggle(isOn: self.$isWelcomed) {
                                Text("Welcomed").offset(x: -16)
                            }
                            .onAppear {
                                isWelcomed = userSettings.isWelcomed
                            }
                            .padding(.trailing, 8)
                            
                            Toggle(isOn: self.$isAccount) {
                                Text("Account").offset(x: -16)
                            }
                            .onAppear {
                                isAccount = userSettings.isAccount
                            }
                            .padding(.trailing, 8)
                            
                            Toggle(isOn: self.$isPrivacy) {
                                Text("Privacy").offset(x: -16)
                            }
                            .onAppear {
                                isPrivacy = userSettings.isPrivacy
                            }
                            .padding(.trailing, 8)
                            
                            Toggle(isOn: self.$isLicensed) {
                                Text("License").offset(x: -16)
                            }
                            .onAppear {
                                isLicensed = userSettings.isLicensed
                            }
                            .padding(.trailing, 8)

                        }
                        .offset(x: 16)
                        // end form
                        
                        //---

                        Section(header: Text("User Settings").offset(x: -16)) {
                            
                            /// Delete All Settings Button
                            Button(action: {
                                showAlert = true
                            }
                            ) {
                                HStack {
                                    Text("Delete All").offset(x: -16)
                                Spacer()
                                Image(systemName: "minus.circle")
                                    .imageScale(.large)
                                }
                            }
                            .alert(isPresented: $showAlert, content: {
                                let firstButton = Alert.Button.default(Text("Cancel"))
                                let secondButton = Alert.Button.destructive(Text("Continue")) {
                                    performDeleteAll()
                                    showAlert = false
                                }
                                return Alert(title: Text("Warning!"), message: Text("Are you sure you want to delete All Settings?"), primaryButton: firstButton, secondaryButton: secondButton)
                                })
                            .padding(.trailing, 8)
                            
                            
                            /// Delete User Settings Button
                            Button(action: {
                                showAlert = true
                            }
                            ) {
                                HStack {
                                    Text("Delete User Settings").offset(x: -16)
                                Spacer()
                                Image(systemName: "minus.circle")
                                    .imageScale(.large)
                                }
                            }
                            .alert(isPresented: $showAlert, content: {
                                let firstButton = Alert.Button.default(Text("Cancel"))
                                let secondButton = Alert.Button.destructive(Text("Continue")) {
                                    performDeleteUserSettings()
                                    showAlert = false
                                }
                                return Alert(title: Text("Warning!"), message: Text("Are you sure you want to delete your User Settings information?"), primaryButton: firstButton, secondaryButton: secondButton)
                                })
                            .padding(.trailing, 8)

                        }
                        .offset(x: 16)
                        
                        // Start System Info
                        Section(header: Text("System").offset(x: -16)) {
                            NavigationLink(destination: SystemInfoView()) {
                                HStack {
                                    Text("System info").offset(x: -16)
                                }
                            }
                            NavigationLink(
                                destination: ReviewDocView(title: "Settings",
                                subtitle: "Review Setttings",
                                content: mySettingsContent,
                                isReviewed: .constant(false)
                                )) {
                                HStack {
                                    Text("Review Settings")
                                }
                                .offset(x: -16)
                                .onDisappear {
                                    mySettingsContent = AppValue.displaySettings
                                }
                            }

                        }
                        .offset(x: 16)
                        .padding(.trailing, 8)
                        // end System Info

                    }
                    // end section
                    
                    

                    /* end stuff within our area */
                    Spacer()
                    Spacer().frame(height: 30)
                }
                .background(Color(UIColor.systemGroupedBackground))
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Developer")
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
                            // Do right away
                            userSettings.isOnboarded = isOnboarded
                            userSettings.isTerms = isTerms
                            userSettings.isWelcomed = isWelcomed
                            userSettings.isAccount = isAccount
                            userSettings.isPrivacy = isPrivacy
                            userSettings.isLicensed = isLicensed

                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save")
                        }
                    }
                })
                .onAppear {
                    /// load up when the view appears so that if you make a change and come back while still in the setting menu the values are current.
                    mySettingsContent = AppValue.displaySettings
                }
            }
        }
    }


    func performDeleteUserSettings() {
        
        userSettings.firstname = ""
        userSettings.lastname = ""
        userSettings.email = ""
        userSettings.avatar = AppDefault.avatar
        userSettings.alias = ""
        userSettings.phoneCell = ""

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: Notification.Name("isLoggedOut"), object: nil)
        }
        self.presentationMode.wrappedValue.dismiss()
    }

    func performDeleteAll() {
        // delete core data for these entities

//        let serialQueue = DispatchQueue(label: "delete.all.serial.queue")
//
//        serialQueue.async {
//            let defaults = UserDefaults.standard
//            let dictionary = defaults.dictionaryRepresentation()
//            dictionary.keys.forEach { key in
//                defaults.removeObject(forKey: key)
//            }
//        }
        
        userSettings.firstname = ""
        userSettings.lastname = ""
        userSettings.email = ""
        userSettings.avatar = AppDefault.avatar
        userSettings.alias = ""
        userSettings.phoneCell = ""
        
        userSettings.isOnboarded = false
        userSettings.isTerms = false
        userSettings.isWelcomed = false
        userSettings.isAccount = false
        userSettings.isPrivacy = false
        userSettings.isLicensed = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NotificationCenter.default.post(name: Notification.Name("isReset"), object: nil)
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}



struct DeveloperSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperSettingsView()
            .environmentObject(UserSettings())
    }
}


