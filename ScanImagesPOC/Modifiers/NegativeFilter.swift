//
//  NegativeFilter.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 23/03/23.
//

import Foundation
import CoreImage

struct NegativeFilter: ImageModifier {
    static let name: String = "CIColorInvert"

    func apply(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: NegativeFilter.name)!
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage!
    }
}
