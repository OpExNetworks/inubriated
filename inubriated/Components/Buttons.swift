//  Buttons.swift
//  inubriated
//
//  Created by David Holeman on 6/2/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

import SwiftUI

struct btnPreviousView: View {
    var body: some View {
        HStack {
            Image(systemName: "arrow.left")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
                .padding()
                .background(Color.clear)
                .clipShape(Circle())
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}
