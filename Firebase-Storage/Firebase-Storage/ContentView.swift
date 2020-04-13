//
//  ContentView.swift
//  Firebase-Storage
//
//  Created by Prasad on 4/13/20.
//  Copyright © 2020 MVSS Prasad. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FirebaseImage(id: "Steve.jpg")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
