//  SystemInfoView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct SystemInfoView: View {

    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        VStack {
            HStack() {
                VStack(alignment: .leading) {
                    Text("Email:").fontWeight(.bold)
                    Text(userSettings.email)
                }
                Spacer()
            }
            .padding(.top, 8)

            HStack() {
                VStack(alignment: .leading) {
                    Text("Device:").fontWeight(.bold)
                    Text(SystemInfo.deviceCode)
                }
                Spacer()
            }
            .padding(.top, 8)
            
            HStack() {
                VStack(alignment: .leading) {
                    Text("OS Version:").fontWeight(.bold)
                    Text(SystemInfo.os)
                }
                Spacer()
            }
            .padding(.top, 8)

            HStack() {
                VStack(alignment: .leading) {
                    Text("App Release:").fontWeight(.bold)
                    Text(AppInfo.release)
                }
                Spacer()
            }
            .padding(.top, 8)
            
            Spacer()

        }
        .padding(.leading, 12)

    }
}


struct SystemInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SystemInfoView()
            .environmentObject(UserSettings())
    }
}

