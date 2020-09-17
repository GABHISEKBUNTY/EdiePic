//
//  ImagePicker.swift
//  EdiePic
//
//  Created by G Abhisek on 30/08/20.
//  Copyright © 2020 G Abhisek. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Combine

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: Image?
    @Binding var filteredImage: [Image]?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        var filteredImage: [Image]?

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = Image(uiImage: image)
                prepareFilters(image: image)
                parent.filteredImage = filteredImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: PRepare filters
extension ImagePicker.Coordinator {
    private func prepareFilters(image: UIImage) {
        if let image = getSepiaImageForSelectedImage(inputImage: image) {
            store(filteredImage: image)
        }
        
        if let image = getVignetteImageForSelectedImage(inputImage: image) {
            store(filteredImage: image)
        }
    }
    
    private func store(filteredImage: Image) {
        if let filteredImages = self.filteredImage {
            self.filteredImage = filteredImages + [filteredImage]
        } else {
            self.filteredImage = [filteredImage]
        }
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
        currentFilter.intensity = 5
        
        guard let outputImage = currentFilter.outputImage,
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return Image(uiImage: UIImage(cgImage: cgimg))
    }
}
