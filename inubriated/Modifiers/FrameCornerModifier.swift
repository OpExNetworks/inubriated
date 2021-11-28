//  FrameCornerModifier.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct FrameCornerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(10)
    }
}
