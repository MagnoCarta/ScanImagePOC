//
//  MorphologicalClosing.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 23/03/23.
//

import Foundation
import CoreImage

struct MorphologicalClosing: ImageModifier {
    static var name: String = "MorphologicalClosing"

    var size: UInt
    
    func apply(to image: CIImage) -> CIImage {
        return image
            .apply(filter: DilationFilter(size: size))
            .apply(filter: ErosionFilter(size: size))
    }
}
