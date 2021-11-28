//  TabBarView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @State var selection: Int
    var body: some View {
        TabView(selection: $selection) {
            HomeView().tabItem {
                Image("symHouse").imageScale(.large)
                Text("Home")
            }.tag(0)
            OtherView().tabItem {
                Image("symOther").imageScale(.large)
                Text("Other")
            }.tag(1)
        }
        //.edgesIgnoringSafeArea(.top)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selection: 0)
            .environmentObject(GlobalVariables())
        //TabBarView().previewDevice("iPhone 8")
    }
}
