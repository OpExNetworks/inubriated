//  WebPageView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct WebPageView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var title: String
    var subtitle: String
    var webURL: String

    @Binding var isReviewed: Bool
    
    var body: some View {

        HStack {
            Color("viewBackgroundColor").frame(width: 8)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 32))
                    .padding(.top, 0)
                    .padding(.bottom, 24)
                Text(subtitle)
                    .font(.system(size: 24))
                    .padding(.bottom, 40)
                
                //----
                SwiftUIWebView(url: URL(string: webURL))
                //----
                
                Spacer()
                
                Button(action: {
                    isReviewed = true
                    self.presentationMode.wrappedValue.dismiss()
                }
                ) {
                    HStack {
                        Text("Reviewed").foregroundColor(.blue)
                    }
                }
                .frame(width: 102)
                .padding(.top)
                .padding(.bottom)
                .buttonStyle(RoundedCorners())
                
            }
            Spacer()
            Color("viewBackgroundColor").frame(width: 8)
        }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("viewBackgroundColor"))
    }
}
struct WebPageView_Previews: PreviewProvider {
    static var previews: some View {
        WebPageView(title: "title", subtitle: "subtitle", webURL: AppValue.licenseURL, isReviewed: .constant(false))
    }
}

