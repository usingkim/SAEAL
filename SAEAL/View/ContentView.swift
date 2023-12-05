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
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("러닝 타임")
                }
            
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
            .tabItem {
//                Image(.film)
//                    .resizable()
//                    .renderingMode(.template)
//                    .frame(width: 20)
//                    .foregroundStyle(Color.blue)
                Image(systemName: "magnifyingglass")
                Text("나의 필모그래피")
            }
            
//            SettingView()
//                .tabItem {
//                    Image(systemName: "gear")
//                    Text("내 정보")
//                }
        }
        .onAppear {
            myMediaService.fetchAllMovie()
        }
        .accentColor(.black)
        
        
    }
    
    
}

#Preview {
    ContentView()
}
