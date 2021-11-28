//  GlobalThemes.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

class GlobalThemes {
 
    static var viewBackgroundGradientLogin: LinearGradient {
        // handle any conditional changes here and pass as values to the returned valueg
        //
        return LinearGradient(gradient: Gradient(colors: [Color("viewBackgroundColorLoginBegin"), Color("viewBackgroundColorLoginEnd")]), startPoint: .top, endPoint: .bottomTrailing)
    }
    
    static var viewBackgroundGradientForgotPassword: LinearGradient {
        // handle any conditional changes here and pass as values to the returned valueg
        //
        return LinearGradient(gradient: Gradient(colors: [Color("viewBackgroundColorLoginBegin"), Color("viewBackgroundColorLoginEnd")]), startPoint: .top, endPoint: .bottomTrailing)
    }

        
}
