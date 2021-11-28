//  MenuSettingsView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct MenuSettingsView: View {
     
    // Allow for control of list background color since this a list is still a UITableView
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        HStack {
            // frame for spacing (or future use to move profile to)
            Color(UIColor.systemBackground).frame(width: 8)
            
            // list of menu options
            List {
                ProfileRow(title:  "<alias>", icon: "person.crop.circle")
                SettingsRow(title: "Account", icon: "creditcard", destinationView: UserAccountView())
                SettingsRow(title: "Settings", icon: "slider.horizontal.3", destinationView: UserSettingsView())
                SettingsRow(title: "Support", icon: "lifepreserver", destinationView: UserSupportView())
                //#if DEBUG
                SettingsRow(title: "Developer", icon: "slider.horizontal.3", destinationView: DeveloperSettingsView())
                //#endif
                SignOutRow(title: "Sign Out", icon: "square.and.arrow.up")
                VersionRow()
            }
            .background(Color(UIColor.systemBackground))  // Set the background color of the list
            .frame(width: AppValue.settingsMenuWidth).offset(x: -8)
            Color(UIColor.systemBackground).frame(width: AppValue.screen.width - AppValue.settingsMenuWidth - 32).opacity(0.1)
            Spacer()
        }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
    }
}



struct ProfileRow: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var globalVariables: GlobalVariables
    
    @EnvironmentObject var userSettings: UserSettings
    
    @State var presented = false
    @State var title: String
    
    @State var avatar: UIImage = UIImage(imageLiteralResourceName: "imgAvatarDefault")         //myUserProfile.avatar
    @State var alias: String = UserSettings.init().alias                //"<alias>"            //myUserProfile.alias
    @State var aliasDisplayed: String = AppDefault.alias
    
    var icon: String
    
    var body: some View {
        
        VStack {
            HStack() {
                Button(action: {
                    presented.toggle()
                }) {
                    VStack {

                        Image(uiImage: avatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64, alignment: .center)
                            .clipShape(Circle())
                            .padding(.top, 8)
                            .onAppear {
                                avatar = userSettings.avatar  //TODO: FIX avatar
                                //avatar = UIImage(data: userSettings.avatar2)!
                            }
                            .onChange(of: avatar, perform: { value in
                                avatar = value
                            })  // Pickup change in avatar from UserProfileView which picks it up from the AvatarPickerView
                        
                        Text(aliasDisplayed)
                            //.foregroundColor(.black)
                            .font(.system(size: 18, weight: .regular, design: .default))
                            .onAppear {
                                if alias == "" { aliasDisplayed = AppDefault.alias } else {aliasDisplayed = alias}
                            }
                            .onChange(of: alias, perform: { value in
                                if value == "" { aliasDisplayed = AppDefault.alias } else {aliasDisplayed = alias}
                                }
                            )
                    }
                }
            }
            .fullScreenCover(isPresented: $presented, content: {
                UserProfileView(avatar: $avatar, alias: $alias).environment(\.managedObjectContext, self.viewContext)
            })
        }
        .frame(width: AppValue.settingsMenuWidth, height: 128, alignment: .leading)
        .offset(x: 8 + (AppValue.settingsMenuWidth / 2) - 48, y: 0)
        
        .frame(width: AppValue.settingsMenuWidth , height: 128, alignment: .leading)
        .offset(x: 0, y: 0)

        .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 16))
        .frame(
          minWidth: 0, maxWidth: .infinity,
          minHeight: 44,
          alignment: .leading
        )
        .listRowInsets(EdgeInsets())
        //.background(Color.white)
    }
}


struct SettingsRow<Content: View>: View {
    @Environment(\.managedObjectContext) var viewContext
    @State var presented = false
    
    var title: String
    var icon: String
    var destinationView: Content

    init(title: String, icon: String, destinationView: Content) {
        self.destinationView = destinationView
        self.title = title
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            Button(action: {
                presented.toggle()
            }) {
                HStack() {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .light))
                    .imageScale(.large)
                    .frame(width: 32, height: 32, alignment: .center)
                    .foregroundColor(Color(#colorLiteral(red: 0.662745098, green: 0.7333333333, blue: 0.831372549, alpha: 1)))
                
                Text(title)
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .frame(width: AppValue.settingsMenuWidth - 32 - 16 - 16, alignment: .leading)
                    .padding(.leading, 8)
                }
            }
            .fullScreenCover(isPresented: $presented, content: {
                destinationView.environment(\.managedObjectContext, self.viewContext)
            })
        }
        .frame(width: AppValue.settingsMenuWidth, height: 64, alignment: .leading)
        .offset(x: 8, y: 0)
    }
    
}

struct SignOutRow: View {
    //@Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var globalVariables: GlobalVariables
    
    var title: String
    var icon: String

    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            Button(action: {
////                globalVariables.isLoggedIn = false
//                print("Signed Out!!!")
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    NotificationCenter.default.post(name: Notification.Name("isLoggedOut"), object: nil)
                }
                
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                HStack() {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .light))
                    .imageScale(.large)
                    .frame(width: 32, height: 32, alignment: .center)
                    .foregroundColor(Color(#colorLiteral(red: 0.662745098, green: 0.7333333333, blue: 0.831372549, alpha: 1)))
                
                Text(title)
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .frame(width: AppValue.settingsMenuWidth - 32 - 16 - 16, alignment: .leading)
                    .padding(.leading, 8)
                }
            }
        }
        .frame(width: AppValue.settingsMenuWidth, height: 64, alignment: .leading)
        .offset(x: 8, y: 0)
    }
    
}

struct VersionRow: View {
    //@Environment(\.managedObjectContext) var viewContext
    //@State var presented = false
    
    var body: some View {
        HStack() {
                    Text("version: \(AppInfo.version) (\(AppInfo.build))")
                        .font(.system(size: 10, weight: .regular, design: .default))
                        .frame(width: AppValue.settingsMenuWidth - 32 - 16 - 16, alignment: .leading)
        }
        .frame(width: AppValue.settingsMenuWidth, alignment: .leading)
        .offset(x: 8, y: 0)
        
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
        .frame(
          minWidth: 0, maxWidth: .infinity,
          minHeight: 44,
          alignment: .leading
        )
        .listRowInsets(EdgeInsets())
        //.background(Color.white)
       
    }
    
}

struct MenuSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MenuSettingsView()
            .environmentObject(GlobalVariables())
    }
}

