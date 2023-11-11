//
//  ContentView.swift
//  RunningTime
//
//  Created by 김유진 on 11/8/23.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var myMedias: MyMediaService = MyMediaService()
    
    var body: some View {
        TabView {
            NavigationStack {
                SearchView(myMedias: myMedias)
            }
            .tabItem { Text("검색") }
            
            NavigationStack {
                MyMediaView(myMedias: myMedias)
            }
            .tabItem { Text("필모") }
        }
        
        
    }
    
    
}

#Preview {
    ContentView()
}
