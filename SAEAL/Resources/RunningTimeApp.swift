//
//  RunningTimeApp.swift
//  RunningTime
//
//  Created by 김유진 on 11/8/23.
//

import SwiftUI

@main
struct RunningTimeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MyMediaService())
        }
    }
}
