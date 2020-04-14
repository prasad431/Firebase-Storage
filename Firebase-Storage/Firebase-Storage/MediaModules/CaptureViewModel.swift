//
//  CaptureViewModel.swift
//  Firebase-Storage
//
//  Created by Prasad on 4/13/20.
//  Copyright © 2020 MVSS Prasad. All rights reserved.
//

import SwiftUI

struct CaptureImageView {
    
    /// MARK: - Properties
    @Binding var isShown: Bool
    @Binding var image: Image?
    var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, isShown: $isShown, image: $image)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            picker.sourceType = .camera
        }else if sourceType != .camera {
            picker.sourceType = sourceType
        }else {
            picker.sourceType = .photoLibrary
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}
