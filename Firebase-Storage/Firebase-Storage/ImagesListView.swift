//
//  ImagesListView.swift
//  Firebase-Storage
//
//  Created by Nikhil on 4/13/20.
//  Copyright © 2020 MVSS Prasad. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import Firebase
import Combine
import FirebaseUI

class FirebaseData: ObservableObject {
    let willChange = PassthroughSubject<[StorageReference]?, Never>()
    @Published var images_list: [StorageReference]? = nil  {
        didSet { willChange.send(images_list) }
    }
    
    func downloadData(_ reference: StorageReference,_ child: String,_ pageToken: String? = nil) {
        reference.child(child)
        let pageHandler: (StorageListResult, Error?) -> Void = { (result, error) in
            if let error = error {
                print("encountered with error\(error)")
            }
            print(result.prefixes)
            for item in result.items {
                self.images_list?.append(item)
            }
            
            if let token = result.pageToken {
                self.downloadData(reference, child, token)
            }
        }
        
        if let pageToken = pageToken {
            reference.list(withMaxResults: 1, pageToken: pageToken, completion: pageHandler)
        } else {
            reference.list(withMaxResults: 10, completion: pageHandler)
        }
    }
}
struct ImageData: Identifiable {
    var id: String = UUID().uuidString
    
    let image_name: String!
    let image_fullPath: String!
    let image_bucket: String!
    init(_ name: String,_ fullpath: String,_ bucket: String) {
        self.image_name = name
        self.image_bucket = bucket
        self.image_fullPath = fullpath
    }
}
struct ImagesListView: View {
    @ObservedObject private var firebaseData: FirebaseData
    var image_names: [ImageData]? = nil
    init(reference: StorageReference, path: String) {
        self.firebaseData = FirebaseData()
        firebaseData.downloadData(reference, path)
        for item in firebaseData.images_list! {
            image_names!.append(ImageData(item.name, item.fullPath, item.bucket))
        }
    }
    
    func setImageToImageView(imageView: UIImageView,_ reference: StorageReference) {
        imageView.sd_setImage(with: reference, placeholderImage: UIImage(named: "images_placeholder.png")!)
    }
    
    var body: some View {
        List{
            ForEach(image_names!) {image_data in
                Text(image_data.image_name)
            }
            
        }
    }
    
    
}

struct ImagesListView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesListView(reference: Storage.storage().reference(), path: "/assets/images")
    }
}
