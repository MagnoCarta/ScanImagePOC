//
//  HighContrastFilter.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 22/03/23.
//

import Foundation
import CoreImage

struct HighContrastFilter: ImageModifier {
    static let name: String = "CIColorControls"
    
    var contrastLevel: Float = 0

    func apply(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: HighContrastFilter.name,
                              parameters: [kCIInputContrastKey: contrastLevel])!
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage!
    }
}
