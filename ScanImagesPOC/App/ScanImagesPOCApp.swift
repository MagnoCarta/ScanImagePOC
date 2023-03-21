//
//  ScanImagesPOCApp.swift
//  ScanImagesPOC
//
//  Created by Gilberto Magno on 21/03/23.
//

import SwiftUI

@main
struct ScanImagesPOCApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ScanView(viewModel: ScanViewModel())
        }
    }
}
