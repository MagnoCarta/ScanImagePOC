//
//  GrayFilter.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 22/03/23.
//

import Foundation
import CoreImage

struct GrayFilter: ImageModifier {
    static let name: String = "CIPhotoEffectMono"

    func apply(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: GrayFilter.name)!
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage!
    }
}
