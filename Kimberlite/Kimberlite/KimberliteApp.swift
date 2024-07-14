//
//  KimberliteApp.swift
//  Kimberlite
//
//  Created by Rania Rejdal on 2024-07-14.
//

import SwiftUI

@main
struct KimberliteApp: App {
    var body: some Scene {
        WindowGroup {
//            DashboardView()
//            DashboardBackgroundView()
            DashboardBackgroundView(url: Bundle.main.url(forResource: "MorningSunny", withExtension: "mp4")!)
        }
    }
}
