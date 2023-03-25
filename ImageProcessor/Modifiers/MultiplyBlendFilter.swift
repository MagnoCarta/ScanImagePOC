//
//  MultiplyBlendFilter.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 23/03/23.
//

import Foundation
import CoreImage

struct MultiplyBlendFilter: ImageModifier {
    static let name: String = "CIMultiplyBlendMode"

    var maskImage: CIImage
    
    func apply(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: MultiplyBlendFilter.name,
                              parameters: [kCIInputBackgroundImageKey: maskImage])!
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage!
    }
}
