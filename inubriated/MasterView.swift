//  MasterView.swift
//  inubriated
//
//  Created by David Holeman on 6/2/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var globalVariables: GlobalVariables
    @EnvironmentObject var userSettings: UserSettings
    
    @EnvironmentObject var viewRouteControllerOnboard: ViewRouteControllerOnboard
    
    var body: some View {

        VStack {
            if userSettings.isOnboarded == false {
                OnboardLaunchView()
            } else if userSettings.isTerms == false {
                TermsView()
            } else if userSettings.isWelcomed == false {
                WelcomeView()
            } else if globalVariables.isLoggedIn == false {
                LoginView()
            } else {
                MainView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("isOnboarded")), perform: { _ in
            globalVariables.isLoggedIn = true
            userSettings.isOnboarded = true
            userSettings.isTerms = true      // We set this to true because accepting the terms is part of the onboard flow.  We don't want to make the user do it twice
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("isTerms")), perform: { _ in
            userSettings.isTerms = true
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("isWelcomed")), perform: { _ in
            userSettings.isWelcomed = true
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("isReset")), perform: { _ in
            userSettings.isOnboarded = false
            userSettings.isTerms = false
            userSettings.isWelcomed = false
            viewRouteControllerOnboard.currentPageView = .onboardStartView
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("isLoggedIn")), perform: { _ in
            globalVariables.isLoggedIn = true
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("isLoggedOut")), perform: { _ in
            globalVariables.isLoggedIn = false
            if userSettings.isOnboarded == false { viewRouteControllerOnboard.currentPageView = .onboardStartView}
            print("LOGGED OUT")

        })
        .onAppear {
            print("MasterView().onAppear...")
            // load up the FAQs
            let count = SupportFAQs.getFAQs()
            print("^ Count: \(count) based on sections: \(AppValue.sectionTags)")
            
            printUserSettings(description: "MasterView()")
            
        }
    } // end View
} // end MasterView


struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
            .environmentObject(GlobalVariables())
            .environmentObject(UserSettings())
            .environmentObject(ViewRouteControllerOnboard())
    }
}

