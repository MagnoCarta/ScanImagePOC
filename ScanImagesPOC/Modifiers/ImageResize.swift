//
//  ImageResize.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 23/03/23.
//

import Foundation
import CoreImage

struct ImageResize: ImageModifier {
    static let name: String = "CILanczosScaleTransform"

    var size: CGSize

    init(width: CGFloat = 720, height: CGFloat = 1080) {
        self.size = CGSize(width: width, height: height)
    }
    
    func apply(to image: CIImage) -> CIImage {
        let scaleX = size.width / image.extent.width
        let scaleY = size.height / image.extent.height

        let filter = CIFilter(name: ImageResize.name,
                              parameters: [kCIInputScaleKey: max(scaleX, scaleY)])!
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage!
    }
}
