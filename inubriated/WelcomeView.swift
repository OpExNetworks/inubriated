//  WelcomeView.swift
//  inubriated
//
//  Created by David Holeman on 6/2/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import UIKit
import SwiftUI

struct WelcomeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var globalVariables = GlobalVariables()

    @State var isLastPage: Bool = false
    
    var subviews = [
        UIHostingController(rootView: Subview(imageString: "meditating")),
        UIHostingController(rootView: Subview(imageString: "skydiving")),
        UIHostingController(rootView: Subview(imageString: "sitting"))
    ]
    
    var titles = [
        "Take some time out",
        "Conquer personal hindrances",
        "Create a peaceful mind"
    ]
    
    var captions =  [
        "Take your time out and bring awareness into your everyday life",
        "Meditating helps you dealing with anxiety and other psychic problems",
        "Regular medidation sessions creates a peaceful inner mind"
    ]
    
    @State var currentPageIndex = 0
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
                    .frame(minHeight: 400, idealHeight: 500, maxHeight: 600)
                    .onChange(of: currentPageIndex, perform: { value in
                        /// Number of pages via array index so is always one less than total  "subviews.count - 1"
                        if currentPageIndex == 2 { isLastPage = true } else { isLastPage = false }
                    })
                Group {
                    Text(titles[currentPageIndex])
                        .font(.title)
                        .frame(height: 40)
                    Text(captions[currentPageIndex])
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50, alignment: .leading)
                    .lineLimit(nil)
                }
                .padding(.top)
                .padding(.leading)
                Spacer()
                
                HStack {
                    PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                        .frame(width: 75)
                    Text("swipe image")
                        .offset(x: -8)
                    Spacer()
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            print("isWelcomed: Notified")
                            NotificationCenter.default.post(name: Notification.Name("isWelcomed"), object: nil)
                        }
                        //self.presentationMode.wrappedValue.dismiss()
                    }
                    ) {
                        HStack {
                            Image(systemName: "arrow.right")
                            .resizable()
                            .foregroundColor(isLastPage ? .white : .clear)
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(isLastPage ? Color("btnNextWelcome") : Color.clear)
                            .cornerRadius(30)
                        }
                    }
                    //.frame(width: 102)
                    .disabled(isLastPage ? false : true)
                    Spacer().frame(width: 16)
                    
                } // end HStack
                .frame(height: 80)
                Spacer().frame(height: 30)
            } // end VStack
        } // end HStack
        .background(Color("viewBackgroundColorWelcome"))
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        
    } // end view
} // end struc

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

// MARK: - Subviews
struct Subview: View {
    var imageString: String
    var body: some View {
            Image(imageString)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
        }
}

struct Subview_Previews: PreviewProvider {
    static var previews: some View {
        Subview(imageString: "meditating")
    }
}


// MARK: -
struct PageViewController: UIViewControllerRepresentable {
    
    @Binding var currentPageIndex: Int
    
    var viewControllers: [UIViewController]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [viewControllers[currentPageIndex]], direction: .forward, animated: true)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        var parent: PageViewController

        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            //retrieves the index of the currently displayed view controller
            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
                 return nil
             }
            
            //shows the last view controller when the user swipes back from the first view controller
            if index == 0 {
                return parent.viewControllers.last
            }
 
            //show the view controller before the currently displayed view controller
            return parent.viewControllers[index - 1]
            
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            //retrieves the index of the currently displayed view controller
            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
                return nil
            }
            //shows the first view controller when the user swipes further from the last view controller
            if index + 1 == parent.viewControllers.count {
                return parent.viewControllers.first
            }
            //show the view controller after the currently displayed view controller
            return parent.viewControllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = parent.viewControllers.firstIndex(of: visibleViewController)
            {
                parent.currentPageIndex = index
            }
        }
    }
    
}

// MARK: -
struct PageControl: UIViewRepresentable {
    
    var numberOfPages: Int
    
    @Binding var currentPageIndex: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.currentPageIndicatorTintColor = UIColor.orange
        control.pageIndicatorTintColor = UIColor.gray

        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPageIndex
    }
    
}
