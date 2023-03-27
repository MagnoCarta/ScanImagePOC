//
//  CorrectorView.swift
//  ScanImagesPOC
//
//  Created by Gilberto Magno on 23/03/23.
//

import Foundation
import CoreImage


import SwiftUI
import VisionKit

struct CorrectorView: View {
    @ObservedObject var viewModel: CorrectorViewModel
    var body: some View {
        NavigationView {
        List {
            if let error = viewModel.errorMessage {
                Text(error)
            } else {
                ForEach(viewModel.imageArray, id: \.self) { image in
                    Image(uiImage: foo(self.viewModel.rightAnswer!))
                        .resizable()
                        .aspectRatio(contentMode: .fit).contextMenu {
                           Button {
                               self.viewModel.calculateNote(of: image, given: self.viewModel.rightAnswer!)
                           } label: {
                            Label("NADA", systemImage: "square.and.arrow.up")
                           }
                           Divider()
                            Button {
                                viewModel.removeImage(image: image)
                            } label: {
                             Label("Deletar Gabarito", systemImage: "delete.left")
                            }

                        }
                }
            }
         }.navigationTitle("Tela pra corrigir provas")
        .navigationBarItems(leading: Button(action: {
            let items = viewModel.imageArray
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController?.present(ac, animated: true)
        }, label: {
            Text("Share All Images")
        }).disabled(viewModel.imageArray.count > -1), trailing: Button(action: {
            UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController?.present(viewModel.getDocumentCameraViewController(), animated: true, completion: nil)
        }, label: {
            Text("Scan New Answers Sheet")
        }))
        
        }
    }

    func foo(_ image: UIImage) -> UIImage {
        
        let processor = ImageProcessor()

        let image = self.viewModel.rightAnswer!
        let ciImage = CIImage(image: image, options: [.colorSpace: NSNull()])!
        let mask = image
        let ciMask = CIImage(image: mask, options: [.colorSpace: NSNull()])!
        let negativeMask = ciMask
            .apply(filter: ImageResize(width: ciMask.extent.width, height: ciMask.extent.height))
            .apply(filter: GrayFilter())
            .apply(filter: HighContrastFilter(contrastLevel: 10))
            .apply(filter: NegativeFilter())
            .apply(filter: MorphologicalOpening(size: 5))
            .apply(filter: ErosionFilter(size: 20))
            .apply(filter: DilationFilter(size: 10))

        let finalImage = ciImage
            .apply(filter: ImageResize(width: negativeMask.extent.width, height: negativeMask.extent.height))
            .apply(filter: GrayFilter())
            .apply(filter: HighContrastFilter(contrastLevel: 10))
            .apply(filter: NegativeFilter())
            .apply(filter: MorphologicalOpening(size: 5))
            .apply(filter: ErosionFilter(size: 20))
            .apply(filter: DilationFilter(size: 10))
            .apply(filter: MultiplyBlendFilter(maskImage: negativeMask))

        let croppedImage = processor.crop(finalImage, 50)
        let renderedImage = processor.render(ciImage: croppedImage)
        print("A nota foi:", processor.countConnectedComponents(of: renderedImage))
        
        return renderedImage
    }
}

