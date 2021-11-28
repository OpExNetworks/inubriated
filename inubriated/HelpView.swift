//  HelpView.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userSettings: UserSettings
    
    @State private var searching = false
    @State private var searchInput: String = ""
    
    @State var isExpanded: Bool = UserSettings.init().isFaqExpanded
    
    var body: some View {
        NavigationView {
            HStack {
                Spacer().frame(width: 16)
                VStack {
                    // start search bar
                    
                    ZStack {
                        // Background Color
                        Color("searchBarBackgroundColor").cornerRadius(5.0)
                        // Custom Search Bar (Search Bar + 'Cancel' Button)
                        HStack {
                            // Search Bar
                            HStack {
                                // Magnifying Glass Icon
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color(.gray))

                                // Search Area TextField
                                TextField("", text: $searchInput)
                                    .onChange(of: searchInput, perform: { searchText in
                                        searching = true
                                        searchInput = searchInput.lowercased()  // force lower case
                                        if searchText.count >= 3 {
                                            //print(searchInput)
                                            var mySectionIndex = 0
                                            faqTableSearch.removeAll()
                                            while mySectionIndex < faqTable.count {
                                                //print("\(faqTable[mySectionIndex].section):")
                                                var myFaqIndex = 0
                                                while myFaqIndex < faqTable[mySectionIndex].faq.count {
                                                    if faqTable[mySectionIndex]
                                                        .faq[myFaqIndex]
                                                        //.title  // we are searching title
                                                        .search   // we are searching search fields
                                                        .lowercased()
                                                        .contains(searchInput.lowercased()) {
                                                            // load into searchResults
    //                                                        print(
    //                                                            faqTable[mySectionIndex].section,
    //                                                            faqTable[mySectionIndex].faq[myFaqIndex].title
    //                                                        )
                                                        
                                                        // start add
                                                        
                                                        // if section exists then append the faq
                                                        if faqTableSearch.contains(where: { $0.section == faqTable[mySectionIndex].section }) {
                                                            let faqChild = FaqChild(
                                                                id: faqTable[mySectionIndex].faq[myFaqIndex].id,
                                                                author: faqTable[mySectionIndex].faq[myFaqIndex].author,
                                                                hidden: faqTable[mySectionIndex].faq[myFaqIndex].hidden,
                                                                position: faqTable[mySectionIndex].faq[myFaqIndex].position,
                                                                title: faqTable[mySectionIndex].faq[myFaqIndex].title,
                                                                summary: faqTable[mySectionIndex].faq[myFaqIndex].summary,
                                                                search: faqTable[mySectionIndex].faq[myFaqIndex].search,
                                                                body: faqTable[mySectionIndex].faq[myFaqIndex].body
                                                            )
                                                            /// need to find the section in the search table it's in then append it to that section.
                                                            var index = 0
                                                            while index < faqTableSearch.count {
                                                                if faqTableSearch[index].section == faqTable[mySectionIndex].section {
                                                                    faqTableSearch[index].faq.append(faqChild)
                                                                }
                                                                index = index + 1
                                                            }
                                                            //faqTableSearch[mySectionIndex].faq.append(faqChild)
                                                        } else {
                                                            //print("new section add")
                                                            // The section was not found so create the section and first faq
                                                            let faqChild = FaqChild(
                                                                id: faqTable[mySectionIndex].faq[myFaqIndex].id,
                                                                author: faqTable[mySectionIndex].faq[myFaqIndex].author,
                                                                hidden: faqTable[mySectionIndex].faq[myFaqIndex].hidden,
                                                                position: faqTable[mySectionIndex].faq[myFaqIndex].position,
                                                                title: faqTable[mySectionIndex].faq[myFaqIndex].title,
                                                                summary: faqTable[mySectionIndex].faq[myFaqIndex].summary,
                                                                search: faqTable[mySectionIndex].faq[myFaqIndex].search,
                                                                body: faqTable[mySectionIndex].faq[myFaqIndex].body
                                                            )
                                                            let faqParent = FaqParent(id: faqTable[mySectionIndex].section, section: faqTable[mySectionIndex].section, faq: [faqChild])
                                                            faqTableSearch.append(faqParent)
                                                        }
                                                        
                                                        // end add
                                                        
                                                        }
                                                    myFaqIndex += 1
                                                }
                                                mySectionIndex += 1
                                            }
                                        } else { searching = false
                                            
                                        }
                                    })
                                    .accentColor(Color("colorBlackWhite"))
                                    .foregroundColor(Color("colorBlackWhite"))
                            }
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                            .background(Color("searchBarTextBackgroundColor").cornerRadius(5.0))

                            // 'Cancel' Button
                            Button(action: {
                                searching = false
                                searchInput = ""

                                // Hide Keyboard
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }, label: {
                                Text("Cancel")
                            })
                                .accentColor(Color.blue)
                                .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 8))
                        }
                        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 5))
                    }
                    .frame(height: 50)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                    // end ZStack Search bar
                    
                    List {
                        ForEach(searching ? faqTableSearch : faqTable) { section in
                            Section(header: Text(section.section)) {
                                ForEach(section.faq) { row in
                                    NavigationLink(destination: FaqView(title: row.title, summary: row.summary, content: row.body)) {
                                        VStack(alignment: .leading) {
                                            Text(row.title)
                                                .font(.custom("Helvetica", size: 16))

                                            if isExpanded {
                                                Spacer()
                                                Text(row.summary)
                                                    .font(.custom("Helvetica", size: 12))
                                                    .foregroundColor(Color(UIColor.systemGray))
                                            }
                                        }
                                    }
                                } // end item
                            } // end section
                            //.font(.custom("Helvetica", size: 17))
                        } // end loop
                    } // end list
                    .frame(width: AppValue.screen.width, alignment: .leading)
                    
                    Spacer()
                    Spacer().frame(height: 30)
                }
                Spacer().frame(width: 16)
            }
            .navigationBarTitle("Search FAQs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("btnCancel")
                            .imageScale(.large)
                        }
                    }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isExpanded.toggle()
                        
                        /// Save the setting so it's remembered
                        userSettings.isFaqExpanded = isExpanded
                    }) {
                        //Image(systemName: isExpanded ? "chevron.up": "chevron.down").imageScale(.large)
                        //Text(isExpanded ? "<...>" : "<>")
                        Text(isExpanded ? "less" : "more")
                        }
                    }
                }
            )
            .onAppear {
                print("HelpView.onAppear...")
                /// We could load the FAQs here but may take too long so for now doing it in MainView() and when the pinned symbol changes in UserSettingsView()
                isExpanded = userSettings.isFaqExpanded
            }
        }
    }
}
struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
            .environmentObject(UserSettings())
    }
}

