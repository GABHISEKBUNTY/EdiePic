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
    private var gridItemLayout = [GridItem(.fixed(70))]
    
    init(imageFilterViewModel: FilterViewModel) {
        self.imageFilterViewModel = imageFilterViewModel
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                if imageFilterViewModel.hasUserSelectedImage {
                    HStack {
                        Spacer()
                        Button(action:{
                            self.imageFilterViewModel.userPressedSaveSelectedFilter()
                        }) {
                            Text("Save")
                                .font(.subheadline)
                        }
                        .frame(width: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                    }
                }
                
                Spacer()
                imageFilterViewModel.displayedImage
                    .swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .border(Color.gray, width: 2)
                Spacer()
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: gridItemLayout, spacing: 20) {
                        ForEach(0..<(imageFilterViewModel.filteredImages.count), id: \.self) { index in
                            Button(action: {
                                self.imageFilterViewModel.userSelectedFilteredImageToDisplay(at: index)
                            }) {
                                self.imageFilterViewModel.filteredImages[index]
                                    .swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 70)
                            }
                            .border(imageFilterViewModel.selectedIndex == index ? Color.blue : Color.clear, width: 2)
                        }
                    }
                    .frame(height: 70)
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
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
            }
            .padding()
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary,
                            imageSelectedSubject: self.imageFilterViewModel.imageSelectedSubject)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(imageFilterViewModel: FilterViewModel(defaultImageName: "scenery"))
    }
}

extension UIImage {
    var swiftUIImage: Image {
        Image(uiImage: self)
    }
}
