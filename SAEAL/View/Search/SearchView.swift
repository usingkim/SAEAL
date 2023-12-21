//
//  SearchView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject var searchVM = SearchViewModel()
    
    var body: some View {
        VStack {
            
            HStack {
                TextField("어떤 영화를 기록하시겠어요?", text: Binding<String>(
                    get: { searchVM.searchText },
                    set: { searchVM.searchText = $0 }
                ), onCommit: {
                    searchVM.search()
                })
                .font(.title05)

                
                if searchVM.searchText != "" {
                    Button {
                        searchVM.searchText = ""
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.gray)
                    }
                }
                
                Button(action: {
                    searchVM.search()
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                })
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            
            if searchVM.movies.isEmpty {
                Spacer()
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        
        if searchVM.movies.isEmpty {
            if !searchVM.isSearched {
                VStack(spacing: 0, content: {
                    Text("검색을 시작해보세요!")
                })
                .font(.body01)
                .foregroundColor(Color.gray)
            }
            else {
                VStack(spacing: 0, content: {
                    Text("검색된 영화가 없습니다")
                })
                .font(.body01)
                .foregroundColor(Color.gray)
            }
        }
        
        
        List(searchVM.movies, id:\.self) { movie in
            HStack {
                NavigationLink {
                    SearchMovieDetailView(movie: movie)
                } label: {
                    OneMovieCapsule(movie: DBMovie(title: movie.title, MovieID: movie.id, runtime: 0, posterLink: movie.posterPath, touchedTime: Date.now, releaseDate: movie.releaseDate, overview: movie.overview, status: -1, actors: [], director: "", myRuntime: 0, startDate: nil, endDate: nil))
                }
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        
        .padding()
    }
    
}

extension SearchView {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SearchView()
}
