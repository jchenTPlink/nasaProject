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
                            
                            NavigationLink(destination: PhotoDetailView(photo: photo)) {
                                
                                VStack {
                                    
                                    Text(photo.id.description)
                                        .bold()
                                        .font(.system(size: 16))
                                        .foregroundStyle(.black)
                                    
                                    WebImage(url: URL(string: photo.imageSource))
                                        .resizable()
                                        .indicator(.activity)
                                        .aspectRatio(contentMode: .fit)
                                    
                                }
                                
                            }
                                .padding([.vertical])
                                .buttonStyle(PlainButtonStyle())
                            
                            
                        }
                            .padding([.horizontal])
                            .background( RoundedRectangle(cornerRadius: 25).fill(.white).shadow(color: Color.black, radius: 8, x: 0, y: 0)) //TODO get rid of these magic numbers somehow?
                            .padding([.horizontal])
                            .padding([.vertical])
                        
                        
                        
                    }
                    
                }.background(Color.white)
                
            }.toolbar {
                Text("")
            }
            
            
            
        }
        
    }
}

//#Preview {
//    SwiftUIView()
//}
