//
//  MorphologicalOpening.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 23/03/23.
//

import Foundation
import CoreImage

struct MorphologicalOpening: ImageModifier {
    static var name: String = "MorphologicalOpening"

    var size: UInt
    
    func apply(to image: CIImage) -> CIImage {
        return image
            .apply(filter: ErosionFilter(size: size))
            .apply(filter: DilationFilter(size: size))
    }
}
