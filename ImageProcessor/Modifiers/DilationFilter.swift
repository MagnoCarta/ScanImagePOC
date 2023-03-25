//
//  DilationFilter.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 23/03/23.
//

import Foundation
import CoreImage

struct DilationFilter: ImageModifier {
    static let name: String = "CIMorphologyRectangleMinimum"

    var size: UInt
    
    func apply(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: DilationFilter.name)!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(size, forKey: kCIInputWidthKey)
        return filter.outputImage!
    }
}
