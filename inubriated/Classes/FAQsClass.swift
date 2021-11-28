//  FAQsClass.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import Foundation

struct Faqs : Decodable {
    let count: Int
    let next_page: String?
    let page: Int
    let page_count: Int
    let per_page: Int
    let previous_page: String?
    let faqs: [Faq]
    let sort_by: String
    let sort_order: String
}
struct Faq : Decodable {
    let id: String
    let author: String
    let hidden: Bool
    let position: Int
    let created_at: String
    let updated_at: String
    let title: String
    let search: String
    let summary: String
    let body: String
    let section_names: [String]
    let label_names: [String]
}


struct FaqParent : Identifiable {
    var id: String
    var section: String
    var faq: [FaqChild]
}
struct FaqChild : Identifiable {
    let id: String
    let author: String
    let hidden: Bool
    let position: Int
    let title: String
    let summary: String
    let search: String
    let body: String
}

// set for global access to the structures
var faqTable = [FaqParent]()
var faqTableSearch = [FaqParent]()


class SupportFAQ
{
    let title: String
    let article_id: String
    let body: String
    
    init(title: String, article_id: String, body: String) {
        self.title = title
        self.article_id = article_id
        self.body = body
    }
    
}

class SupportFAQs
{
    var sections: String
    var faqs: [SupportFAQ]
    
    init(section: String, includeFAQs: [SupportFAQ]) {
        sections = section
        faqs = includeFAQs
    }
    
    class func getFAQs() -> Int {
    
        // Clear storag
        clearDataFAQs()
        
        // Load up the articles
        let count = loadArticles(sections: AppValue.sectionTags)
        
        return count
    }
    
    class func updatePinnedUnicode() {
        var mySectionIndex = 0
        while mySectionIndex < faqTable.count {
            // convert
            let result = convertPinned(string: faqTable[mySectionIndex].section)
            // replace
            faqTable[mySectionIndex].section = result
            mySectionIndex = mySectionIndex + 1
        }
    }
    
    private class func clearDataFAQs() {
        faqTable.removeAll()
        faqTableSearch.removeAll()
    }
    
    // Not used right now as I am pulling data from file version of JSON
    /*
    private class func buildURL(page: Int) -> URL {
        let myPage = String(page)
        let myURL = "https://www.opexnetworks.com/api/v1/faqs.json?&page=" + myPage
        return URL(string: myURL)!
    }
    */
    
    private class func convertPinned(string: String?) -> String {
        // find the "*" and swap for new string
        if let range = string?.range(of: "*|PINNED|*") {
            //let string = string![range.lowerBound...].replacingOccurrences(of: "*|PINNED|*", with: myUserSettings.pinnedUnicode)
            
            /// how to get to one of the user defaults directly since we are in a function and can't use via ObservedObject.  We just need to read the saved value so all good... I think.
            let unicode = UserSettings.self.init().pinnedUnicode
            let string = string![range.lowerBound...].replacingOccurrences(of: "*|PINNED|*", with: unicode)
            
            
            return string
        } else {
            return string!
        }
    }
    
    private class func loadArticles(sections: [[String]]) -> Int {
        // Initialize some counters
        var page_index = 1
        var page_count = 1
        var article_count = 0
        
        // Loop through the pages
        while page_index <= page_count {
            
            // Activate when using web based source
            /*
            let myURL = buildURL(page: page_index)
            let myData = try! Data(contentsOf: myURL)
            */
            
            let myPath = Bundle.main.path(forResource: "FAQs", ofType: "json")
            
            do {
                let myData = try Data(contentsOf: URL(fileURLWithPath: myPath!), options: .alwaysMapped)
                // Decode the json
                let decoded = try JSONDecoder().decode(Faqs.self, from: myData)
                
                // Update the number to the number of pages detected
                page_count = decoded.page_count
                
                // Loop through the faqs
                var myIndex = 0
                while myIndex < decoded.faqs.count {
                    if decoded.faqs[myIndex].hidden == false {
                        // Loop through the sections for matches.  We are looking for a match on each individual label not literal combined labels.
                        if (sections[0][0] != "" ) {
                            for var i in 0..<decoded.faqs[myIndex].section_names.count {
                                for var j in 0..<sections.count {
                                    if decoded.faqs[myIndex].section_names[i] == sections[j][0] {
                                        if faqTable.contains(where: { $0.section == sections[j][1] }) {
                                            // section found so just append faq
                                            let faqChild = FaqChild(
                                                id: decoded.faqs[myIndex].id,
                                                author: decoded.faqs[myIndex].author,
                                                hidden: decoded.faqs[myIndex].hidden,
                                                position: decoded.faqs[myIndex].position,
                                                title: decoded.faqs[myIndex].title,
                                                summary: decoded.faqs[myIndex].summary,
                                                search: decoded.faqs[myIndex].search,
                                                body: decoded.faqs[myIndex].body
                                            )
                                            var index = 0
                                            while index < faqTable.count {
                                                if faqTable[index].section == sections[j][1] {
                                                    //print("update section matching",faqTable[index].section,sections[j][1])
                                                    faqTable[index].faq.append(faqChild)
                                                }
                                                index = index + 1
                                            }
                                            
                                            //let result = convertPinned(string: sections[j][1])
                                            //print("convertPinned (appended):", result)

                                            //print("+ Matched | updated section: ",sections[j][1], j,  decoded.faqs[myIndex].id, decoded.faqs[myIndex].title)
                                        } else {
                                            // section not found so create both section and faq
                                            let faqChild = FaqChild(
                                                id: decoded.faqs[myIndex].id,
                                                author: decoded.faqs[myIndex].author,
                                                hidden: decoded.faqs[myIndex].hidden,
                                                position: decoded.faqs[myIndex].position,
                                                title: decoded.faqs[myIndex].title,
                                                summary: decoded.faqs[myIndex].summary,
                                                search: decoded.faqs[myIndex].search,
                                                body: decoded.faqs[myIndex].body
                                            )
                                            
                                            //let result = convertPinned(string: sections[j][1])
                                            //print("convertPinned (created):", result)
                                            //let faqParent = FaqParent(section: result, faq: [faqChild])
                                            
                                            let faqParent = FaqParent(id: sections[j][1], section: sections[j][1], faq: [faqChild])
                                            
                                            faqTable.append(faqParent)

                                            //print("+ Matched | new section:     ",sections[j][1], j,  decoded.faqs[myIndex].id, decoded.faqs[myIndex].title)
                                        }
                                        article_count = article_count + 1
                                    }
                                    j += 1
                                }
                                i += 1
                            }
                        } else {
                            // label was blank so load them all
                            if faqTable.contains(where: { $0.section == "All" }) {
                                // section found so just append faq
                                let faqChild = FaqChild(
                                    id: decoded.faqs[myIndex].id,
                                    author: decoded.faqs[myIndex].author,
                                    hidden: decoded.faqs[myIndex].hidden,
                                    position: decoded.faqs[myIndex].position,
                                    title: decoded.faqs[myIndex].title,
                                    summary: decoded.faqs[myIndex].summary,
                                    search: decoded.faqs[myIndex].search,
                                    body: decoded.faqs[myIndex].body
                                )
                                faqTable[0].faq.append(faqChild)
                                //print("Matched | updated section: ","All",  decoded.faqs[myIndex].id, decoded.faqs[myIndex].title)
                            } else {
                                // section not found so create both section and faq
                                let faqChild = FaqChild(
                                    id: decoded.faqs[myIndex].id,
                                    author: decoded.faqs[myIndex].author,
                                    hidden: decoded.faqs[myIndex].hidden,
                                    position: decoded.faqs[myIndex].position,
                                    title: decoded.faqs[myIndex].title,
                                    summary: decoded.faqs[myIndex].summary,
                                    search: decoded.faqs[myIndex].search,
                                    body: decoded.faqs[myIndex].body
                                )
                                let faqParent = FaqParent(id: "All", section: "All", faq: [faqChild])
                                faqTable.append(faqParent)
                                //print("Matched | new section: ","All",  decoded.faqs[myIndex].id, decoded.faqs[myIndex].title)
                            }
                            print("^ All faqs: \(article_count) \(decoded.faqs[myIndex].title)")
                            article_count = article_count + 1
                        }
                        
                        myIndex = myIndex + 1
                        
                    }
                    
                }
                page_index = page_index + 1
            } catch {
                print("Error:", error)
            }
        }
        faqTable.sort { $0.section < $1.section }  // sort by section
        
        // now sweep through the array and update the Pinned Unicode value into designated field
        updatePinnedUnicode()
        
        // load up the search array.  Do this after the faqTable load as it's making a copy
        
        // loadFaqSearch()  // TODO: load up and print out so we can see what's screwed up
        
        return article_count
    }
    
    class func printFAQs() {
        var mySectionIndex = 0
        while mySectionIndex < faqTable.count {
            print("\(faqTable[mySectionIndex].section):")
            var myFaqIndex = 0
            while myFaqIndex < faqTable[mySectionIndex].faq.count {
                print(".", faqTable[mySectionIndex].faq[myFaqIndex].title)
                myFaqIndex += 1
            }
            mySectionIndex += 1
        }
    }
    
    private class func loadFaqSearch() {
        var i = 0
        //print("section: ", faqTable.count)
        while i < faqTable.count {
            // does section exist
            //("section:",faqTable[i].section)
            var j = 0
            //print("faq count:", faqTable[i].faq.count)
            while j < faqTable[i].faq.count {
                //print("faq:", faqTable[i].section, faqTable[i].faq[j].title)
                if faqTableSearch.contains(where: { $0.section == faqTable[i].section }) {
                    //print("section matched:", i, faqTable[i].section)
                    let faqChild = FaqChild(
                        id: faqTable[i].faq[j].id,
                        author: faqTable[i].faq[j].author,
                        hidden: faqTable[i].faq[j].hidden,
                        position: faqTable[i].faq[j].position,
                        title: faqTable[i].faq[j].title,
                        summary: faqTable[i].faq[j].summary,
                        search: faqTable[i].faq[j].search,
                        body: faqTable[i].faq[j].body
                    )
                    faqTableSearch[i].faq.append(faqChild)
                } else {
                    //print("section new:", i, faqTable[i].section)
                    // section not found so create both section and faq
                    let faqChild = FaqChild(
                        id: faqTable[i].faq[j].id,
                        author: faqTable[i].faq[j].author,
                        hidden: faqTable[i].faq[j].hidden,
                        position: faqTable[i].faq[j].position,
                        title: faqTable[i].faq[j].title,
                        summary: faqTable[i].faq[j].summary,
                        search: faqTable[i].faq[j].search,
                        body: faqTable[i].faq[j].body
                    )
                    let faqParent = FaqParent(id: faqTable[i].section, section: faqTable[i].section, faq: [faqChild])
                    faqTableSearch.append(faqParent)
                }
                j = j + 1
            }
            i = i + 1
        }
    }


}

