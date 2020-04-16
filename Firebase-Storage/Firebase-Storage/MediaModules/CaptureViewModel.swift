//
//  CaptureViewModel.swift
//  Firebase-Storage
//
//  Created by Prasad on 4/13/20.
//  Copyright © 2020 MVSS Prasad. All rights reserved.
//

import SwiftUI

/*struct CaptureImageView {
 
 /// MARK: - Properties
 @Binding var isShown: Bool
 @Binding var image: Image?
 var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
 @Environment(\.presentationMode) var presentationMode
 
 func makeCoordinator() -> Coordinator {
 return Coordinator(parent: self, isShown: $isShown, image: $image)
 }
 }*/

struct CaptureImageView: View {
    @State var showImagePicker: Bool = false
    @State var image: Image? = nil
    
    var body: some View {
        VStack {
            image?.resizable()
                .frame(width: 250, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10).padding(30)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                self.image = Image(uiImage: image)
            }
        }
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
    
    final class Coordinator: NSObject,
        UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {
        
        @Binding
        private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void
        
        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as! URL
            let imageName = imageUrl.lastPathComponent
            guard let compressedImage = UIImage(data: uiImage.jpegData(compressionQuality: 0.35)!)else {return}
            
            PostServiceFireBase.create(for: compressedImage, path: "/assets/images/" + imageName) { (downloadUrl) in
                print(downloadUrl!)
            }
            onImagePicked(uiImage)
            presentationMode.dismiss()
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
}

/*extension CaptureImageView: UIViewControllerRepresentable {
 
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
 }*/

final class Coordinator: NSObject,
    UINavigationControllerDelegate,
UIImagePickerControllerDelegate {
    
    @Binding
    private var presentationMode: PresentationMode
    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage) -> Void
    
    init(presentationMode: Binding<PresentationMode>,
         sourceType: UIImagePickerController.SourceType,
         onImagePicked: @escaping (UIImage) -> Void) {
        _presentationMode = presentationMode
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        onImagePicked(uiImage)
        presentationMode.dismiss()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presentationMode.dismiss()
    }
    
}
