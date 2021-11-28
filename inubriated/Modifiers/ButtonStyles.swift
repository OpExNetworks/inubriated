//  ButtonStyles.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct RoundedCorners: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(10)
            .overlay(
                   RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1)
               )
    }
}
