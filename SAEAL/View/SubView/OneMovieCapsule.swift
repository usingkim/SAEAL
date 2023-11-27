//
//  OneMovieCapsule.swift
//  SAEAL
//
//  Created by 김유진 on 11/27/23.
//

import SwiftUI
import Kingfisher

struct OneMovieCapsule: View {
    @State var movie: DBMovie
    
    var body: some View {
        VStack {
            if let poster = movie.posterLink {
                KFImage(URL(string: APIConstant.imageURL + poster))
                    .retry(maxCount: 3, interval: .seconds(5))
                    .resizable()
                    .frame(width: 120, height: 150)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                Text(movie.title)
                    .lineLimit(1)
            }
            else {
                Spacer()
                Text(movie.title)
            }
        }
    }
}

#Preview {
    OneMovieCapsule(movie: DBMovie())
}
