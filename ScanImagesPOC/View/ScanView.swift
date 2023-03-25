//
//  ScanView.swift
//  ScanImagesPOC
//
//  Created by Gilberto Magno on 21/03/23.
//

import SwiftUI
import VisionKit

struct ScanView: View {
    @ObservedObject var viewModel: ScanViewModel
    @State var isTimeToNavigate: Bool = false
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
                               self.isTimeToNavigate = true
                           } label: {
                            Label("Utilizar Gabarito", systemImage: "square.and.arrow.up")
                           }
                           Divider()
                            Button {
                                viewModel.removeImage(image: image)
                            } label: {
                             Label("Deletar Gabarito", systemImage: "delete.left")
                            }
                            
                        }
                }
                NavigationLink("Tela de corrigir prova", isActive: self.$isTimeToNavigate) {
                    CorrectorView(viewModel: CorrectorViewModel(imageArray: [], rightAnswer: self.viewModel.imageArray.first))
                }
//                .sheet(isPresented: self.$isTimeToNavigate) {
//                            CorrectorView(viewModel: CorrectorViewModel())
//                        }
            }
         }.navigationTitle("Vinson kit Demo")
        .navigationBarItems(leading: Button(action: {
            let items = viewModel.imageArray
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController?.present(ac, animated: true)
        }, label: {
            Text("Share All Images")
        }).disabled(viewModel.imageArray.count == 0), trailing: Button(action: {
            UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController?.present(viewModel.getDocumentCameraViewController(), animated: true, completion: nil)
        }, label: {
            Text("Scan New Answers Sheet")
        }))
        
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView(viewModel: ScanViewModel())
    }
}
