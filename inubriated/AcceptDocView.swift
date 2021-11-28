//  AcceptDocView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpEx Networks, LLC. All rights reserved.
//

import SwiftUI

//final class ViewModel : ObservableObject {
//
//@Published var score : Bool
//   init(_ value : Bool) {
//       self.score = value
//   }
//}

struct AcceptDocView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var globalVariables = GlobalVariables()
    
    var title: String
    var subtitle: String
    var content: String
    @Binding var isAccepted: Bool
    
    var body: some View {
        HStack {
            Color("viewTermsBackgroundColor").frame(width: 8)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 32))
                    .padding(.top, 0)
                    .padding(.bottom, 24)
                Text(subtitle)
                    .font(.system(size: 24))
                    .padding(.bottom, 40)
                HTMLStringView(htmlContent: content)
                
                Spacer()
                
                HStack {
                    /// Declined button
                    Button(action: {
                        isAccepted = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    ) {
                        HStack {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding()
                                .background(Color("btnPrev}"))
                                .cornerRadius(30)
                            Text("Decline").foregroundColor(.blue)
                        }
                    }

                    .disabled(isAccepted ? false : true)
                    
                    Spacer()
                    
                    /// Accepted button
                    Button(action: {
                        isAccepted = true
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    ) {
                        HStack {
                            Text("accept")
                                .foregroundColor(isAccepted ? .blue : .blue)
                            Image(systemName: "arrow.right")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding()
                                .background(isAccepted ? Color("btnNext") : Color("btnNext"))
                                .cornerRadius(30)
                        }
                    }
                    //.disabled(isAccepted)  // Disable if if already isAccepted is true
                }
            }
            Spacer()
            Color("viewTermsBackgroundColor").frame(width: 8)
        }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("viewTermsBackgroundColor"))
    }
}

struct AcceptDocView_Previews: PreviewProvider {
    static var previews: some View {
        AcceptDocView(title: "<Title>", subtitle: "<Instructions...> You must scroll to the end to Accept.", content: termsData.content, isAccepted: .constant(false))
    }
}
