//
//  FilterView.swift
//  EdiePic
//
//  Created by G Abhisek on 24/08/20.
//  Copyright © 2020 G Abhisek. All rights reserved.
//

import SwiftUI
import Combine

struct FilterView: View {
    @State private var isShowPhotoLibrary = false
    @ObservedObject var imageFilterViewModel: FilterViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                imageFilterViewModel.displayedImage
                    .swiftUIImage
                    .resizable()
                    .scaledToFit()
                
                Spacer(minLength: 40)
                ScrollView([.horizontal]) {
                    HStack {
                        ForEach(0..<(imageFilterViewModel.filteredImages.count), id: \.self) { index in
                            Button(action: {
                                self.imageFilterViewModel.displayedImage = self.imageFilterViewModel.filteredImages[index]
                            }) {
                                self.imageFilterViewModel.filteredImages[index]
                                    .swiftUIImage
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: 100, height: 70)
                            }
                        }
                    }
                }
                
                Button(action: {
                    self.isShowPhotoLibrary = true
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                        
                        Text("Photo library")
                            .font(.headline)
                        }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
            }
            .padding()
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary,
                            selectedImage: self.$imageFilterViewModel.selectedImage)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(imageFilterViewModel: FilterViewModel(defaultImageName: "bike"))
    }
}

extension UIImage {
    var swiftUIImage: Image {
        Image(uiImage: self)
    }
}
