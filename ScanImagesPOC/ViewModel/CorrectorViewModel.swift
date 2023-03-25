//
//  CorrectorViewModel.swift
//  ScanImagesPOC
//
//  Created by Gilberto Magno on 23/03/23.
//

import Foundation
import SwiftUI
import VisionKit


final class CorrectorViewModel: NSObject, ObservableObject {
    @Published var errorMessage: String?
    @Published var imageArray: [UIImage] = []
    @Published var rightAnswer: UIImage?
    
    init(errorMessage: String? = nil, imageArray: [UIImage], rightAnswer: UIImage? = nil) {
        self.errorMessage = errorMessage
        self.imageArray = imageArray
        self.rightAnswer = rightAnswer
    }
    
    func getDocumentCameraViewController() -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        return vc
    }
    
    func removeImage(image: UIImage) {
        imageArray.removeAll{$0 == image}
    }
}


extension CorrectorViewModel: VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
      
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
      
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
      print("Did Finish With Scan.")
        for i in 0..<scan.pageCount {
            self.imageArray.append(scan.imageOfPage(at:i))
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func calculateNote(of answer: UIImage, given key: UIImage) {
        
        let processor = ImageProcessor()
        
        let image = answer
        let ciImage = CIImage(image: image, options: [.colorSpace: NSNull()])!
        let mask = key
        let ciMask = CIImage(image: mask, options: [.colorSpace: NSNull()])!
        let negativeMask = ciMask
            .apply(filter: GrayFilter())
            .apply(filter: ImageResize(width: ciMask.extent.width / 2, height: ciMask.extent.height / 2))
            .apply(filter: HighContrastFilter(contrastLevel: 5))
            .apply(filter: NegativeFilter())
            .apply(filter: MorphologicalClosing(size: 10))
        
        
        let finalImage = ciImage
            .apply(filter: GrayFilter())
            .apply(filter: ImageResize(width: negativeMask.extent.width, height: negativeMask.extent.height))
            .apply(filter: HighContrastFilter(contrastLevel: 5))
            .apply(filter: NegativeFilter())
            .apply(filter: MorphologicalClosing(size: 10))
            .apply(filter: MultiplyBlendFilter(maskImage: negativeMask))
        
        let renderedImage = processor.render(ciImage: finalImage)
        print("A nota foi:", processor.countConnectedComponents(of: renderedImage))
    }
}
