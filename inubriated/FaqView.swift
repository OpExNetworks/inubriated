//  FaqView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct FaqView: View {
    
    var title: String?
    var summary: String?
    var content: String?
    
    var body: some View {
        HStack {
            Spacer().frame(width: 16)
            VStack(alignment: .leading) {
                Spacer().frame(height: 30)
                Text(title ?? "no title")
                    .font(.system(size: 24))
                    .fontWeight(.regular)
                    .padding(.bottom, 16)
                Text(summary ?? "no summary")
                    .font(.system(size: 16))
                Spacer().frame(height: 30)
                HStack {
                    let st = content ?? "No Article."
                    let bodyText = "<meta name=viewport content=initial-scale=1.0/>" + "<div style=\"font-family: sans-serif; font-size: 15px\">" + st + "</div>"
                    HTMLStringView(htmlContent: bodyText).opacity(0.8).border(Color.gray, width: 1)
                }
                Spacer().frame(height: 60)
            }
            Spacer().frame(width: 16)
        } // end HStack
        .background(Color("viewBackgroundColor"))
        .navigationBarTitle("FAQ")
        
    } // end View
}

struct FaqView_Previews: PreviewProvider {
    static var previews: some View {
        FaqView(title: "title", content: "content")
    }
}
