//
//  MovieDetailSubView.swift
//  SAEAL
//
//  Created by 김유진 on 11/29/23.
//

import SwiftUI
import Kingfisher

struct MovieDetailSubView: View {
    @State var movie: DBMovie
    
    var body: some View {
        VStack {
            Text(movie.title)
                .font(.title04)
                .lineLimit(2)
            HStack {
                VStack(alignment: .leading, content: {
                    
                    Text("\(movie.releaseDate), \(movie.runtime)분")
                        .font(.body01)
                        .padding(.bottom, 10)
                    if movie.director != "" {
                        Text("감독 : \(movie.director)")
                            .font(.body02)
                            .padding(.bottom, 5)
                    }
                    
                    if !movie.actors.isEmpty {
                        Text("주요 출연진")
                            .font(.body02)
                        ForEach(movie.actors, id:\.self) { actor in
                            Text("- \(actor) ")
                                .font(.body02)
                        }
                    }
                    
                    Spacer()
                })
                .frame(height: 150)
                
                Spacer()
                
                if let poster = movie.posterLink {
                    KFImage(URL(string: APIConstant.imageURL + poster))
                        .retry(maxCount: 3, interval: .seconds(5))
                        .resizable()
                        .frame(width: 100, height: 125)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                else {
                    Image(.film)
                        .resizable()
                        .frame(width: 100, height: 125)
                }
                
            }
            
            Divider()
        }
    }
}

#Preview {
    MovieDetailSubView(movie: DBMovie())
}
