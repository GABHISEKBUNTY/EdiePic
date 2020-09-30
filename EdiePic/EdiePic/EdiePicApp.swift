//
//  EdiePicApp.swift
//  EdiePic
//
//  Created by G Abhisek on 30/09/20.
//

import SwiftUI

@main
struct EdiePicApp: App {
    var body: some Scene {
        WindowGroup {
            FilterView(imageFilterViewModel: FilterViewModel(defaultImageName: "scenery"))
        }
    }
}
