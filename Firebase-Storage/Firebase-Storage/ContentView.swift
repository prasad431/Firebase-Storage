//
//  ContentView.swift
//  Firebase-Storage
//
//  Created by Prasad on 4/13/20.
//  Copyright © 2020 MVSS Prasad. All rights reserved.
//

import SwiftUI
import FirebaseStorage
struct ContentView: View {
    @State var image: Image? = nil
    @State var shown: Bool = false
    @State var isdownloaded: Bool = false
    
    var body: some View {
      ImagesListView()
    }

}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

