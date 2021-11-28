//  OtherView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct OtherView: View {
    
    @EnvironmentObject var globalVariables: GlobalVariables
    
    var body: some View {
        VStack {
            Text("Other")
        }
        .frame(width: AppValue.screen.width)
        .onAppear { globalVariables.isCurrentTabIndex = 1}

    }
}

struct OtherView_Previews: PreviewProvider {
    static var previews: some View {
        OtherView()
            .environmentObject(GlobalVariables())
    }
}
