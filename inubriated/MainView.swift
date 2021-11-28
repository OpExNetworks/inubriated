//  MainView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var globalVariables: GlobalVariables
    @EnvironmentObject var userSettings: UserSettings
    
    //@EnvironmentObject var viewRouteControllerOnboard: ViewRouteControllerOnboard
    
    @State var isShowSettings = false
    @State var isShowHelp = false
    
    @State var viewState = CGSize.zero
    @State var startPos : CGPoint = .zero
    @State var isSwipping = true
    
    var body: some View {
        ZStack {
                /* */
                VStack {
                    HStack() {
                        Button(action: {
                            self.isShowSettings.toggle()
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundColor(Color("colorBlackWhite"))
                                .font(.system(size: 24, weight: .ultraLight))
                                .frame(width: 36, height: 36)
                                .background(Color("btnBackgroundColorAppSettings"))
                                .clipShape(Circle())
                                .modifier(IconShadowModifier()) // use my customer modifier
                        }
                        /* .sheet(isPresented: $showSettings) {
                         SettingsMenuView()
                         }*/
                        Spacer()
                        Text(AppValue.appName)
                        Spacer()
                        Button(action: {self.isShowHelp.toggle() }) {
                            Image(systemName: "questionmark")
                                .foregroundColor(Color("colorBlackWhite"))
                                .font(.system(size: 20, weight: .ultraLight))
                                .frame(width: 36, height: 36)
                                .background(Color("btnBackgroundColorAppSettings"))
                                .clipShape(Circle())
                                .modifier(IconShadowModifier()) // use my customer modifier
                        }
                        .sheet(isPresented: $isShowHelp) {
                            /// Or use MenuHelpView() if you want the FAQ's as an option among others in the same style as the User Settings menu options
                            HelpView()
                        }

                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    Spacer()
                    TabBarView(selection: globalVariables.isCurrentTabIndex)
                }

                if isShowSettings {
                    // blur and move other views and then show settings menu view
                    Color(.systemBackground).frame(width: AppValue.screen.width, height: AppValue.screen.height)  // this is an important cheat to hide buttons and maintain the right distance from the top of the screen.
                    MainView()
                        .offset(x: AppValue.settingsMenuWidth)
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                        .blur(radius: 1)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.viewState = value.translation
                                    if self.isSwipping {
                                        self.startPos = value.location
                                        self.isSwipping.toggle()
                                    }
                                }
                                .onEnded { value in
                                    // if drag is greater than this value
                                    if self.viewState.height > 50 {
                                        self.isShowSettings = false
                                    }
                                    self.viewState = .zero
                                    // evaluate for left swipe direction
                                    let xDist =  abs(value.location.x - self.startPos.x)
                                    let yDist =  abs(value.location.y - self.startPos.y)
                                    if self.startPos.x > value.location.x && yDist < xDist {
                                        self.isShowSettings = false
                                    }
                                    self.isSwipping.toggle()
                                }
                        )

                    MenuSettingsView()
                        //.background(Color.black.opacity(0.2))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.viewState = value.translation
                                    if self.isSwipping {
                                        self.startPos = value.location
                                        self.isSwipping.toggle()
                                    }
                                }
                                .onEnded { value in
                                    // if drag is greater than this value
                                    if self.viewState.height > 50 {
                                        self.isShowSettings = false
                                    }
                                    self.viewState = .zero
                                    // evaluate for left swipe direction
                                    let xDist =  abs(value.location.x - self.startPos.x)
                                    let yDist =  abs(value.location.y - self.startPos.y)
                                    if self.startPos.x > value.location.x && yDist < xDist {
                                        self.isShowSettings = false
                                    }
                                    self.isSwipping.toggle()
                                }
                        )
                } // end VStack
                /* */
        }
        .onAppear {
            print("MainView().onAppear...")
            printUserSettings(description: "MainView()")
        }
        // end ZStack
        
    }
    // end ZStack
}
// end View

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(GlobalVariables())
            .environmentObject(UserSettings())
    }
}

