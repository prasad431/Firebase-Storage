//
//  MediaUpload.swift
//  Firebase-Storage
//
//  Created by Prasad on 4/13/20.
//  Copyright © 2020 MVSS Prasad. All rights reserved.
//

import SwiftUI
import Combine
import UIKit
import FirebaseStorage

struct PostServiceFireBase {
    
    static func create(for image: UIImage,path: String, completion: @escaping (String?) -> ()) {
        let filePath = path
        
        let imageRef = Storage.storage().reference().child(filePath)
        StorageServiceFireBase.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                print("Download url not found or error to upload")
                return completion(nil)
            }
            
            completion(downloadURL.absoluteString)
        }
    }
    
}

struct StorageServiceFireBase {
    
    // provide method for uploading images
    static func uploadImage(_ image: UIImage,at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            return completion(nil)
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let uploadTask = reference.putData(imageData, metadata: metaData) { (metadata, error) in
            guard let metadata = metadata else {
                completion(nil)
                return
            }
            print(metadata.bucket)
            
            reference.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                completion(downloadURL)
            }
        }
        uploadTask.resume()
    }
}
