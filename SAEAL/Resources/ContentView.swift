//
//  ContentView.swift
//  RunningTime
//
//  Created by 김유진 on 11/8/23.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var myMediaService: MyMediaService = MyMediaService()
    
    var body: some View {
        TabView {
            ViewingTimeView(myMediaService: myMediaService)
                .tabItem { Text("시청 시간") }
            
            NavigationStack {
                SearchView(myMediaService: myMediaService)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("검색")
            }
            
            NavigationStack {
                MyMediaView(myMediaService: myMediaService)
            }
            .tabItem { Text("필모그래피") }
            
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("내 정보")
                }
        }
        .onAppear {
            myMediaService.fetchAllMovie()
        }
        
        
    }
    
    
}

#Preview {
    ContentView()
}
