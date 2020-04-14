//
//  MediaStorage.swift
//  Firebase-Storage
//
//  Created by Prasad on 4/13/20.
//  Copyright © 2020 MVSS Prasad. All rights reserved.
//

import SwiftUI
import Combine

import FirebaseStorage

final class Loader : ObservableObject {
    let willChange = PassthroughSubject<Data?, Never>()
    @Published var data: Data? = nil {
        didSet { willChange.send(data) }
    }
    
    init(path urlpath:String,_ id: String){
        let url = urlpath + id
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 1 * 1024 * 228) { data, error in
            if let error = error {
                print("\(error)")
            }
            
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}

var placeholder = UIImage(named: "placeholder.png")!

struct FirebaseImage : View {
    
    init(id: String) {
        placeholder  = UIImage(named: "images_placeholder.png")!
        self.imageLoader = Loader(path: "/assets/images/", id)
    }
    
    @ObservedObject private var imageLoader : Loader
    
    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }
  
    var body: some View {
        Image(uiImage: image ?? placeholder)
            .resizable()
            .aspectRatio(contentMode: .fit)
        
    }
}

#if DEBUG
struct FirebaseImage_Previews : PreviewProvider {
    static var previews: some View {
        FirebaseImage(id: "Steve.jpg")
    }
}
#endif
