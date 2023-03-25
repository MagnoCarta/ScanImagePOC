//
//  ImageModifier.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 22/03/23.
//

import Foundation
import CoreImage

protocol ImageModifier {
    static var name: String { get }
    func apply(to image: CIImage) -> CIImage
}
