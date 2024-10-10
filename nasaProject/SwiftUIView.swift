//
//  SwiftUIView.swift
//  nasaProject
//
//  Created by Jonathan Chen on 10/8/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct SwiftUIView: View {
    
    @StateObject var photosObject: PhotosObject
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                LazyVGrid(columns: Array(repeating:.init(), count: 1)) {
                    
                    ForEach(photosObject.photos, id: \.id) { photo in
                        
                        HStack {
                            
                            VStack {
                                
                                Text(photo.id.description)
                                    .bold()
                                    .font(.system(size: 16))
                                
                                WebImage(url: URL(string: photo.imageSource))
                                    .resizable()
                                    .indicator(.activity)
                                    .aspectRatio(contentMode: .fit)
                                
                            }.padding([.vertical])
                            
                            
                        }.padding([.horizontal])
                        
                        
                        
                    }
                    
                }
                
            }.toolbar {
                
                Button("", systemImage: "line.3.horizontal") {
                    //TODO: organize views by photoID
                }
                
                
            }
            
            
            
        }
        
//        ScrollView {
//            
//            LazyVGrid(columns: Array(repeating:.init(.fixed(300)), count: 1)) {
//                
//                ForEach(photosObject.photos, id: \.id) { photo in
//                    
//                    VStack {
//                        
//                        WebImage(url: URL(string: photo.imageSource))
//                            .resizable()
//                            .indicator(.activity)
//                            .aspectRatio(contentMode: .fit)
//                        
//                        Text(photo.id.description)
//                        Text(photo.earthDate)
//                        
//                    }
//                    
//                }
//                
//            }
//            
//        }
        
    }
}

//#Preview {
//    SwiftUIView()
//}
