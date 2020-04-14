//
//  Coordinator.swift
//  Firebase-Storage
//
//  Created by Prasad on 4/13/20.
//  Copyright © 2020 MVSS Prasad. All rights reserved.
//

import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate {
    
    @Binding var isCoordinatorShown: Bool
    var parentController: CaptureImageView!
    
    @Binding var imageInCoordinator: Image?
    
    
    init(parent: CaptureImageView,isShown: Binding<Bool>, image: Binding<Image?>) {
        parentController = parent
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
    }
}
extension Coordinator: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as! URL
        let imageName = imageUrl.lastPathComponent
        guard let compressedImage = UIImage(data: unwrapImage.jpegData(compressionQuality: 0.35)!)else {return}
        
        PostServiceFireBase.create(for: compressedImage, path: "/assets/images/" + imageName) { (downloadUrl) in
            print(downloadUrl!)
        }
        
        imageInCoordinator = Image(uiImage: compressedImage)
        isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}
