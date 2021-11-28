//  ImagePicker.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import Foundation
import SwiftUI

struct imagePicker:UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isShowingImagePicker: Bool
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = imagePickerCoordinator
    
    var sourceType:UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> imagePickerCoordinator {
        return imagePickerCoordinator(image: $image, isShowingImagePicker: $isShowingImagePicker)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// MARK: - Coordinator
class imagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var image: UIImage?
    @Binding var isShowingImagePicker: Bool
    
    init(image:Binding<UIImage?>, isShowingImagePicker: Binding<Bool>) {
        _image = image
        _isShowingImagePicker = isShowingImagePicker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiimage
            isShowingImagePicker = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShowingImagePicker = false
    }
}

