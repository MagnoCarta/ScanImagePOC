//
//  CIImage.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 23/03/23.
//

import Foundation
import CoreImage

extension CIImage {
    func apply(filter: ImageModifier) -> CIImage {
        filter.apply(to: self)
    }
}
