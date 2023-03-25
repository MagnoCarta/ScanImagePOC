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
                        Image(uiImage: image)
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
}

