//  UserSupportView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI
import MessageUI

struct UserSupportView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userSettings: UserSettings
    
    @State var mySettingsContent: String = AppValue.displaySettings
    
    @State var showMailSheet = false
    @State var alertNoMail = false
    

    // where we can control some of the tables appearance but not much.
    //    init(){
    //        UITableView.appearance().backgroundColor = .clear
    //    }
    
    var body: some View {
        
        NavigationView {
            HStack {
                VStack() {
                    Spacer().frame(height: 16)
                    
                    /* start stuff within our area */
                    Form {
                        VStack(alignment: .leading) {
                            Text("Support!")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.bottom, 1)
                            Text("Support resources...")
                                .font(.system(size: 14))

                        }
                        .frame(width: AppValue.screen.width - 36, height: 120, alignment: .leading)
                        .modifier(FrameCornerModifier())
                        .padding(.bottom, 16)
                        
                        Section(header: Text("FAQs").offset(x: -16)) {
                            NavigationLink(destination: FaqSearchView()) {
                                HStack {
                                    Text("Local FAQs").offset(x: -16)
                                }
                            }
                        }
                        .offset(x: 16)
                        .padding(.trailing, 8)
                        
                        // Start Resources
                        Section(header: Text("Resources").offset(x: -16)) {
                            NavigationLink(destination: SystemInfoView()) {
                                HStack {
                                    Text("Contact Us").offset(x: -16)
                                }
                            }
                            Button(action: {
                                self.showMailSheet.toggle()
                            }) {
                                Text("Email Us")
                            }
                            .offset(x: -16)
                            .onTapGesture {
                                MFMailComposeViewController.canSendMail() ? self.showMailSheet.toggle() : self.alertNoMail.toggle()
                            }

                            .sheet(isPresented: self.$showMailSheet) {
                                MailView(isShowing: self.$showMailSheet,
                                         resultHandler: {
                                            value in
                                            switch value {
                                            case .success(let result):
                                                switch result {
                                                case .cancelled:
                                                    print("cancelled")
                                                case .failed:
                                                    print("failed")
                                                case .saved:
                                                    print("saved")
                                                default:
                                                    print("sent")
                                                }
                                            case .failure(let error):
                                                print("error: \(error.localizedDescription)")
                                            }
                                },
                                         subject: "Support Request",
                                         toRecipients: [AppValue.supportEmail],
                                         ccRecipients: [""],
                                         bccRecipients: [""],
                                         messageBody: "I need support with... " + "\r\n\n",
                                         isHtml: false)
                                .safe()
                            }
                            
                            
                            .alert(isPresented: self.$alertNoMail) {
                                Alert(title: Text("NO MAIL SETUP"))
                            }
                        }
                        .offset(x: 16)
                        // end Resources
                        
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
                    // end form

                    /* end stuff within our area */
                    Spacer()
                    Spacer().frame(height: 30)  // This gap puts some separate between the keyboard and the scrolled field
                }
                .background(Color(UIColor.systemGroupedBackground))
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Help")
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
                    }
                )
                // end
            }
            .onAppear {
                /// load up when the view appears so that if you make a change and come back while still in the setting menu the values are current.
                mySettingsContent = AppValue.displaySettings
                
            }
        }
    }
}


struct UserSupportView_Previews: PreviewProvider {
    static var previews: some View {
        UserSupportView()
    }
}
