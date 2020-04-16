//
//  ImagesListView.swift
//  Firebase-Storage
//
//  Created by Nikhil on 4/13/20.
//  Copyright © 2020 MVSS Prasad. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import Combine


final class ImagesList: ObservableObject {
    let willChange = PassthroughSubject<[ImageData]?, Never>()
    @Published var data: [ImageData] = [] {
        didSet { willChange.send(data) }
    }
    init() {
        let storageRef = Storage.storage().reference().child("/assets/images")
        storageRef.listAll { (result, error) in
            for item in result.items {
                self.data.append(ImageData(item.name, item.fullPath, item.bucket))
            }
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

struct ImageRow: View {
    var imageData: ImageData
    var body: some View {
        FirebaseImage(id: imageData.image_name)
    }
}

struct ImagesListView: View {
    @ObservedObject private var imageList : ImagesList
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        self.imageList = ImagesList()
    }
    
    
    var body: some View {
        Group{
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back to Home")
            }.padding(20)
            List(self.imageList.data) { data in
                ImageRow(imageData: data).padding(10)
            }
        }.onAppear {
            print("presentationMode = \(self.presentationMode)")
        }
    }
    
    
}

struct ImagesListView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesListView()
    }
}
