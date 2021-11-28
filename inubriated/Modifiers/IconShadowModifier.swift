//  IconShadowModifier.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct IconShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            // Shadow from two angles.  First one broad and tight the other tight to edge
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 6)
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}
