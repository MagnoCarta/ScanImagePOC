//
//  CompositingBlendFilter.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 23/03/23.
//

import Foundation
import CoreImage

struct CompositingBlendFilter: ImageModifier {
    static let name: String = "CIMinimumCompositing"

    var maskImage: CIImage
    
    func apply(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: CompositingBlendFilter.name)!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(maskImage, forKey: kCIInputBackgroundImageKey)
        return filter.outputImage!
    }
}
