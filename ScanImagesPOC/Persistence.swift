//
//  Persistence.swift
//  ScanImagesPOC
//
//  Created by Gilberto Magno on 21/03/23.
//

import CoreData

struct PersistenceController {
    //TODO: Implement Coredata.
}

//
//func foo() {
//let processor = ImageProcessor()
//
//let image = UIImage(named: "answer")!
//let ciImage = CIImage(image: image, options: [.colorSpace: NSNull()])!
//let mask = UIImage(named: "mask")!
//let ciMask = CIImage(image: mask, options: [.colorSpace: NSNull()])!
//let negativeMask = processor.apply(filter: NegativeFilter(), to: ciMask)
//
//let finalImage = ciImage
//    .apply(filter: ImageResize(width: ciMask.extent.width, height: ciMask.extent.height))
//    .apply(filter: GrayFilter())
//    .apply(filter: HighContrastFilter(contrastLevel: 5))
//    .apply(filter: NegativeFilter())
//    .apply(filter: MultiplyBlendFilter(maskImage: negativeMask))
//    .apply(filter: MorphologicalOpening(size: 10))
//
//self.image = processor.render(ciImage: finalImage)
//print("A nota foi:", processor.countConnectedComponents(of: self.image!))
//}
