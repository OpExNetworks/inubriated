//  ReviewDocView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct ReviewDocView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var title: String
    var subtitle: String
    var content: String
    
    @Binding var isReviewed: Bool
    
    var body: some View {

        HStack {
            Color(UIColor.clear).frame(width: 8)
            VStack(alignment: .leading) {
                Spacer().frame(height: 20)
                Text(title)
                    .font(.system(size: 32))
                    .padding(.top, 0)
                    .padding(.bottom, 24)
                Text(subtitle)
                    .font(.system(size: 24))
                    .padding(.bottom, 40)
                HTMLStringView(htmlContent: content)
                
                Spacer().frame(height: 30)
                Button(action: {
                    isReviewed = true
                    self.presentationMode.wrappedValue.dismiss()
                }
                ) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(Color("btnNextOnboarding"))
                            .cornerRadius(30)
                        Text("Reviewed").foregroundColor(.blue)
                    }
                }
                .padding(0)
                Spacer().frame(height: 30)
                
            }
            // end VStack
            Spacer()
            Color(UIColor.clear).frame(width: 8)
        }
        .background(Color("viewBackgroundColorOnboarding"))
        //.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .edgesIgnoringSafeArea(.bottom)

    }
    
}

struct ReviewDocView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewDocView(title: "<Title>", subtitle: "<sub-title>", content: AppValue.displaySettings, isReviewed: .constant(false))

    }
}
