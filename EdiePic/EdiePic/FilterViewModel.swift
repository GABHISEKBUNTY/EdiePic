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
    @Published var hasUserSelectedImage: Bool = false
    var imageSelectedSubject: PassthroughSubject<UIImage, Never> = PassthroughSubject<UIImage, Never>()
    
    private(set) var selectedIndex: Int = 0
    private var subscriptions = Set<AnyCancellable>()
    private let imageSaver: ImagePersistable
    
    init(defaultImageName: String,
         imageSaver: ImagePersistable = ImageSaver()) {
        let defaultImage = UIImage(named: defaultImageName) ?? UIImage()
        displayedImage = defaultImage
        filteredImages = [defaultImage]
        self.imageSaver = imageSaver
        prepareFilters(image: defaultImage)
        setupBinding()
    }
    
    func userSelectedFilteredImageToDisplay(at index: Int) {
        selectedIndex = index
        displayedImage = filteredImages[index]
    }
    
    func userPressedSaveSelectedFilter() {
        imageSaver.writeToPhotoAlbum(image: filteredImages[selectedIndex])
    }
    
    private func setupBinding() {
        imageSelectedSubject.sink { [weak self] image in
             self?.selectedIndex = 0
             self?.hasUserSelectedImage = true
             self?.filteredImages = [image]
             self?.prepareFilters(image: image)
             self?.displayedImage = image
        }
        .store(in: &subscriptions)
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

protocol ImagePersistable {
    func writeToPhotoAlbum(image: UIImage)
}

class ImageSaver: NSObject, ImagePersistable {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
