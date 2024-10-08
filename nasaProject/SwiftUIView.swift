//
//  SwiftUIView.swift
//  nasaProject
//
//  Created by Jonathan Chen on 10/8/24.
//

import SwiftUI

struct SwiftUIView: View {
    
    @StateObject var photos: PhotosObject
    
    var body: some View {
        Text(String(photos.photos.count))
    }
}

//#Preview {
//    SwiftUIView()
//}
