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
    @State var showView = false

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    self.showView.toggle()
                }){
                    Text("Show Images")
                }.frame(minWidth: 100, maxWidth: 200)
                    .padding(20)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.yellow,Color.red]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .font(.body).padding(10)
                
                Button(action: {
                    self.shown.toggle()
                }) {
                    Text("Select & Upload Photo")
                }.frame(minWidth: 0, maxWidth: 200)
                    .padding(20)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.red, Color.blue, Color.gray, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .font(.body)
                
                image?.resizable()
                    .frame(width: 250, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10).padding(30)
                if (shown) {
                    CaptureImageView(showImagePicker: shown, image: image)
                }
            }
            
        }.sheet(isPresented: $showView) {
            ImagesListView()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

