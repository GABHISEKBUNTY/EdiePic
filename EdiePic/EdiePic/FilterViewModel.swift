//
//  FilterViewModel.swift
//  EdiePic
//
//  Created by G Abhisek on 25/09/20.
//  Copyright © 2020 G Abhisek. All rights reserved.
//

import SwiftUI
import Combine
import CoreImage
import CoreImage.CIFilterBuiltins

class FilterViewModel: ObservableObject {
    @Published var displayedImage: UIImage
    @Published var filteredImages: [UIImage]
    @Published var selectedImage: UIImage
    private var subscriptions = Set<AnyCancellable>()
    
    init(defaultImageName: String) {
        let defaultImage = UIImage(named: defaultImageName) ?? UIImage()
        displayedImage = defaultImage
        selectedImage = defaultImage
        filteredImages = [defaultImage]
        setupBinding()
    }
    
    func userSelectedImage(image: UIImage) {
        filteredImages = [image]
        prepareFilters(image: image)
        displayedImage = image
    }
    
    private func setupBinding() {
        $selectedImage.sink { [weak self] image in
             self?.filteredImages = [image]
             self?.prepareFilters(image: image)
             self?.displayedImage = image
        }.store(in: &subscriptions)
    }
}

// MARK: PRepare filters
extension FilterViewModel {
    private func prepareFilters(image: UIImage) {
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
    
    private func store(filteredImage: UIImage) {
        self.filteredImages = self.filteredImages + [filteredImage]
    }
    
    private func getSepiaImageForSelectedImage(inputImage: UIImage) -> UIImage? {
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.sepiaTone()
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
        
        guard let outputImage = currentFilter.outputImage,
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgimg)
    }
    
    private func getVignetteImageForSelectedImage(inputImage: UIImage) -> UIImage? {
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.vignette()
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 4
        
        guard let outputImage = currentFilter.outputImage,
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgimg)
    }
    
    private func getDitherImageForSelectedImage(inputImage: UIImage) -> UIImage? {
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.dither()
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
        
        guard let outputImage = currentFilter.outputImage,
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgimg)
    }
}
