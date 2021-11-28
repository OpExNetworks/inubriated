//  UserProfileView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var globalVariables: GlobalVariables
    @EnvironmentObject var userSettings: UserSettings
    
    @Binding var avatar: UIImage
    @Binding var alias: String

    @State var birthday: Date = Date()

    @State var isChanged: Bool = false
    
    var body: some View {
        
        NavigationView {
            HStack {
                VStack() {
                    Spacer().frame(height: 16)

                    Form {
                        /* start stuff within our area */
                        VStack(alignment: .leading) {
                            Text("Profile Settings!")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.bottom, 1)
                            Text("How you appear to others...")
                                .font(.system(size: 14))
                        }
                        .frame(width: AppValue.screen.width - 36, height: 120, alignment: .leading)
                        .modifier(FrameCornerModifier())
                        .padding(.bottom, 16)
                        
                        Section(header: Text("Avatar").offset(x: -16)) {
                            NavigationLink(destination: AvatarPickerView(title: "Avatar", subtitle: "Select an image then pinch and drag to size.  Press Accept to save.", avatar: $avatar)) {
                                HStack {
                                    Image(uiImage: avatar)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24, alignment: .center)
                                        .clipShape(Circle())
                                        .offset(x: -20)
                                        .onChange(of: avatar, perform: { value in
                                            //print("avatar changed in userprofileview")
                                        })
                                    Text("Select image from photos")
                                        .offset(x: -16)
                                }
                            }
                        }
                        .offset(x: 16)
                        .padding(.trailing, 8)
                        
                        Section(header: Text("alias").offset(x:-16), footer: Text("Your public name").offset(x: -16)) {
                            TextField("your online identifier", text: $alias)
                                .offset(x: -16)
                        }
                        .offset(x: 16)
                        .onChange(of: alias, perform: { value in
                            if alias != userSettings.alias { isChanged = true } else { isChanged = false }
                        })
                        
                        Section(header: Text("Birthday").offset(x: -16)) {
                            DatePicker(selection: $birthday, in: ...Date(), displayedComponents: .date, label: { Text("Birthday").offset(x: -16) })
                                .datePickerStyle(CompactDatePickerStyle())
                                .onAppear {
                                    // set the birthday to today if zero date value  TODO: reset zero if today
                                    if ZeroDateCheck(date: userSettings.birthday) == true {birthday = Date()} else {birthday = userSettings.birthday}
                                }
                                .onChange(of: birthday, perform: { value in
                                    if birthday != userSettings.birthday { isChanged = true } else { isChanged = false }
                                })
                        }
                        .offset(x: 16)
                        .padding(.trailing, 8)
                    }

                    /* end stuff within our area */
                    Spacer()
                    Spacer().frame(height: 30)
                }
                .background(Color(UIColor.systemGroupedBackground))
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            /// Reset since we are abandoning changes.  This makes sure that the old value is passed pack up in the alias binding to the MenuSettingsView()
                            alias = userSettings.alias
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("btnCancel")
                                .imageScale(.large)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if alias != userSettings.alias {
                                userSettings.alias = alias.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                            if birthday != userSettings.birthday { userSettings.birthday = birthday }
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text(isChanged ? "Save" : "Done" )
                        }
                    }
            })
                //Color.blue.frame(width: 8)
            }
        }
        .onAppear {
            /// load up when the view appears so that if you make a change and come back while still in the setting menu the values are current.
            avatar = userSettings.avatar  //TODO: FIX avatar
            //avatar = UIImage(data: userSettings.avatar2)!
            alias = userSettings.alias
            birthday = userSettings.birthday
            isChanged = false
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(avatar: .constant(UIImage(imageLiteralResourceName: "imgAvatarDefault")), alias: .constant("alias"))
            .environmentObject(UserSettings())
    }
}
