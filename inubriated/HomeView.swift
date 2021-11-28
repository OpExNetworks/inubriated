//  HomeView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var globalVariables: GlobalVariables
    
    var body: some View {
        VStack {
            Text("Home View")

        }
        .frame(width: AppValue.screen.width)
        .onAppear { globalVariables.isCurrentTabIndex = 0 }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(GlobalVariables())
    }
}
