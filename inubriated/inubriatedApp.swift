//  inubriatedApp.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

@main
struct inubriatedApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MasterView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(GlobalVariables())
                .environmentObject(UserSettings())
                .environmentObject(ViewRouteControllerOnboard())
        }
    }
}
