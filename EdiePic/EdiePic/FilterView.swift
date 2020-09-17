//
//  FilterView.swift
//  EdiePic
//
//  Created by G Abhisek on 24/08/20.
//  Copyright © 2020 G Abhisek. All rights reserved.
//

import SwiftUI
import Combine
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterModel {
    let image: Image
    let filterName: String
}

struct FilterView: View {
    @State private var isShowPhotoLibrary = false
    @State private var selectedImage: Image?
    @State private var filteredImage: [Image]?
    
    init() {
        loadImage()
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                selectedImage?
                    .resizable()
                    .scaledToFit()
                
                Spacer(minLength: 40)
                ScrollView([.horizontal]) {
                    HStack {
                        ForEach(0..<(filteredImage?.count ?? 0), id: \.self) { index in
                            Button(action: {
                                self.selectedImage = self.filteredImage?[index]
                            }) {
                                self.filteredImage?[index]
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
                            selectedImage: self.$selectedImage, filteredImage: self.$filteredImage)
            }
        }
    }
    
    private func loadImage() {
        prepareFilters()
    }
    
    private func prepareFilters() {
        if let image = getSepiaImageForSelectedImage() {
            store(filteredImage: image)
        }
        
        if let image = getVignetteImageForSelectedImage() {
            store(filteredImage: image)
        }
        
        selectedImage = filteredImage?[0]
    }
    
    private func store(filteredImage: Image) {
        if let filteredImages = self.filteredImage {
            self.filteredImage = filteredImages + [filteredImage]
        } else {
            self.filteredImage = [filteredImage]
        }
    }
    
    private func getSepiaImageForSelectedImage() -> Image? {
        guard let inputImage = UIImage(named: "bike") else { return nil }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.sepiaTone()
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
        
        guard let outputImage = currentFilter.outputImage,
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return Image(uiImage: UIImage(cgImage: cgimg))
    }
    
    private func getVignetteImageForSelectedImage() -> Image? {
        guard let inputImage = UIImage(named: "bike") else { return nil }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.vignette()
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 5
        
        guard let outputImage = currentFilter.outputImage,
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return Image(uiImage: UIImage(cgImage: cgimg))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
