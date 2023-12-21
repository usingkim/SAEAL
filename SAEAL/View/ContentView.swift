//
//  ContentView.swift
//  RunningTime
//
//  Created by 김유진 on 11/8/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            NavigationStack {
                ViewingTimeView()
            }
            .tabItem {
                Image(.timetab)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .scaledToFit()
                Text("러닝 타임")
            }
            
            NavigationStack {
                SearchView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                    .frame(width: 20, height: 20)
                Text("검색")
            }
            
            NavigationStack {
                MyMediaView()
            }
            .tabItem {
                Image(.filmotab)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .scaledToFit()
                Text("나의 필모그래피")
            }
        }
        .accentColor(.black)
    }
    
}

#Preview {
    ContentView()
}
