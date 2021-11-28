//  UserSettingsView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct UserSettingsView: View {

    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var globalVariables: GlobalVariables
    @EnvironmentObject var userSettings: UserSettings
    
    @State var mySettingsContent: String = AppValue.displaySettings
    
    @State var avatar: UIImage = UserSettings.init().avatar
    
    @State var isChanged: Bool = false
    @State var isLandingPageIndex: Int = myLandingPageIndex(string: UserSettings.init().landingPage)
    @State var isPinnedSymbolIndex: Int = myPinnedSymbolIndex(string: UserSettings.init().pinnedUnicode)
    
    var body: some View {
        
        NavigationView {
            HStack {
                VStack() {
                    Spacer().frame(height: 16)
                    
                    /* start stuff within our area */
                   
                    Form {
                        
                        VStack(alignment: .leading) {
                            Text("User Settings!")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.bottom, 1)

                            Text("These settings control the behavior of your app...")
                                .font(.system(size: 14))
                        }
                        .frame(width: AppValue.screen.width - 36, height: 120, alignment: .leading)
                        .modifier(FrameCornerModifier())
                        .padding(.bottom, 16)

                        Section(header: Text("Behavior").offset(x: -16)) {
                            
                            /// Pick the default landing page the user would like the app to start on.
                            Picker(selection: $isLandingPageIndex, label: Text("Landing page").offset(x: -16)) {
                                ForEach(0 ..< AppValue.landingPageOptions.count) {
                                    Text(AppValue.landingPageOptions[$0])
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            .onChange(of: isLandingPageIndex, perform: { value in
                                if value != myLandingPageIndex(string: userSettings.landingPage) { isChanged = true }
                            })
                            
                            /// Pick the desiired symbol the user would like to have for pinned FAQs
                            Picker(selection: $isPinnedSymbolIndex, label: Text("Symbol for Pinned FAQs").offset(x: -16)) {
                                ForEach(0 ..< AppValue.pinnedUnicodeOptions.count) {
                                    Text(AppValue.pinnedUnicodeOptions[$0])
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            .onChange(of: isPinnedSymbolIndex, perform: { value in
                                if value != globalVariables.isPinnedSymbolIndex { isChanged = true }
                            })
                        }
                        .offset(x: 16)
                        .padding(.trailing, 8)
                        // end Behavior
                        
                        Section(header: Text("Security").offset(x: -16)) {
                            NavigationLink(destination: UserSecurityView()) {
                                HStack {
                                    Text("Security").offset(x: -16)
                                }
                            }
                        }
                        .offset(x: 16)
                        .padding(.trailing, 8)
                        // end Security Info
                        
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
                    
                    
                    /* end stuff within our area */
                    Spacer()
                    Spacer().frame(height: 30)
                }

                .background(Color(UIColor.systemGroupedBackground))
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            // Reset the index back to the saved setting to clean things up since this is a global variable
                            self.globalVariables.isLandingPageIndex = myLandingPageIndex(string: userSettings.landingPage)
                            self.globalVariables.isPinnedSymbolIndex = myPinnedSymbolIndex(string: userSettings.pinnedUnicode)
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("btnCancel")
                                .imageScale(.large)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            
                            if myLandingPageName(index: isLandingPageIndex) != userSettings.landingPage {
                                userSettings.landingPage = myLandingPageName(index: isLandingPageIndex)
                                /// set the current tab index since we have changed the landing page
                                globalVariables.isCurrentTabIndex = myLandingPageIndex(string: userSettings.landingPage)
                            }
                            
                            if myPinnedSymbolName(index: isPinnedSymbolIndex) != userSettings.pinnedUnicode {
                                userSettings.pinnedUnicode = myPinnedSymbolName(index: isPinnedSymbolIndex)
                            }
                            /// Re-running the load wil update the pinnedUnicode symbol properly
                            _ = SupportFAQs.getFAQs()
                            self.presentationMode.wrappedValue.dismiss()

                        }) {
                            Text(isChanged ? "Save" : "Done")
                        }
                    }
                })
            }
        }
        .onAppear {
            isLandingPageIndex = myLandingPageIndex(string: userSettings.landingPage)
            isPinnedSymbolIndex = myPinnedSymbolIndex(string: userSettings.pinnedUnicode)
            isChanged = false
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
            .environmentObject(GlobalVariables())
            .environmentObject(UserSettings())
    }
}


