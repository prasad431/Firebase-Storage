//
//  ContentView.swift
//  Firebase-Storage
//
//  Created by Prasad on 4/13/20.
//  Copyright © 2020 MVSS Prasad. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var image: Image? = nil
    @State var shown: Bool = false
    @State var isdownloaded: Bool = false
    
    var body: some View {
      ZStack {
        VStack {
          Button(action: {
            self.shown.toggle()
          }) {
            Text("Select & Upload Photo")
          }
          image?.resizable()
            .frame(width: 250, height: 200)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            Button(action: {
            }) {
                Text("Display Photos")
            }
        }
        if (shown) {
            CaptureImageView(isShown: $shown, image: $image, sourceType: .savedPhotosAlbum)
        }
      }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

