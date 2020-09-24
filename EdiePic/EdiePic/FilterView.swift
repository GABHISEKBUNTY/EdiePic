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

struct FilterConfig {
    var selectedImage: Image
    var filteredImages: [Image]
    
    init(defaultImageName: String) {
        self.selectedImage = Image(defaultImageName)
        filteredImages = [Image(defaultImageName)]
        prepareFilters(image: UIImage(named: defaultImageName)!)
    }
    
    mutating func userSelectedImage(image: UIImage) {
        filteredImages = [Image(uiImage: image)]
        prepareFilters(image: image)
        selectedImage = Image(uiImage: image)
    }
}

// MARK: PRepare filters
extension FilterConfig {
    private mutating func prepareFilters(image: UIImage) {
        if let image = getSepiaImageForSelectedImage(inputImage: image) {
            store(filteredImage: image)
        }
        
        if let image = getVignetteImageForSelectedImage(inputImage: image) {
            store(filteredImage: image)
        }
        
        if let image = getDitherImageForSelectedImage(inputImage: image) {
            store(filteredImage: image)
        }
    }
    
    private mutating func store(filteredImage: Image) {
        self.filteredImages = self.filteredImages + [filteredImage]
    }
    
    private func getSepiaImageForSelectedImage(inputImage: UIImage) -> Image? {
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
    
    private func getVignetteImageForSelectedImage(inputImage: UIImage) -> Image? {
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.vignette()
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 4
        
        guard let outputImage = currentFilter.outputImage,
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return Image(uiImage: UIImage(cgImage: cgimg))
    }
    
    private func getDitherImageForSelectedImage(inputImage: UIImage) -> Image? {
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.dither()
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
        
        guard let outputImage = currentFilter.outputImage,
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return Image(uiImage: UIImage(cgImage: cgimg))
    }
}


struct FilterView: View {
    @State private var isShowPhotoLibrary = false
    @State private var imageFilterConfig: FilterConfig = FilterConfig(defaultImageName: "bike")
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                imageFilterConfig.selectedImage
                    .resizable()
                    .scaledToFit()
                
                Spacer(minLength: 40)
                ScrollView([.horizontal]) {
                    HStack {
                        ForEach(0..<(imageFilterConfig.filteredImages.count), id: \.self) { index in
                            Button(action: {
                                self.imageFilterConfig.selectedImage = self.imageFilterConfig.filteredImages[index]
                            }) {
                                self.imageFilterConfig.filteredImages[index]
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
                            filterConfig: self.$imageFilterConfig)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
