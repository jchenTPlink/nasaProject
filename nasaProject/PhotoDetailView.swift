//
//  PhotoDetailView.swift
//  nasaProject
//
//  Created by Jonathan Chen on 10/10/24.
//


import SwiftUI

struct PhotoDetailView: View {
    
    var photo: Photo
    
    var body: some View {
        
        VStack {
            
            Text("ID: \(photo.id.description)")
                .padding([.bottom])
            
            Text("Earth Date: \(photo.earthDate.description)")
            
            
        }
        
    }
}
