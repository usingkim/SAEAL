//
//  MyMediaView.swift
//  SAEAL
//
//  Created by 김유진 on 11/10/23.
//

import SwiftUI
import Kingfisher

struct MyMediaView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var myMediaViewModel = MyMediaViewModel()
    
    var body: some View {
        VStack {
            filteringSection
            
            if myMediaViewModel.Movies.isEmpty {
                
                Spacer()
                VStack(spacing: 0, content: {
                    Text("영화 기록을 시작해보세요!")
                    Text("검색 탭으로 이동해 관심있는 영화를 검색해봐요!")
                })
                .font(.body01)
                Spacer()
            }
            
            else if myMediaViewModel.filteredMovies.isEmpty {
                Spacer()
                switch(myMediaViewModel.status) {
                case .bookmark:
                    Text("보고싶은 영화가 없어요").font(.body01)
                case .ing:
                    Text("보는 중인 영화가 없어요").font(.body01)
                case .end:
                    Text("다 본 영화가 없어요").font(.body01)
                case .none:
                    VStack(spacing: 0, content: {
                        Text("영화 기록을 시작해보세요!")
                        Text("검색 탭으로 이동해 관심있는 영화를 검색해봐요!")
                    })
                    .font(.body01)
                }
                
                Spacer()
            }
            
            else {
                List(myMediaViewModel.filteredMovies) { movie in
                    NavigationLink {
                        MyMediaDetailView(movie: movie.toDBMovie())
                    } label: {
                        // MARK: 추후 리팩토링 필요
                        HStack {
                            if let poster = movie.posterLink {
                                KFImage(URL(string: APIConstant.imageURL + poster))
                                    .retry(maxCount: 3, interval: .seconds(5))
                                    .resizable()
                                    .frame(width: 80, height: 100)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            else {
                                Image(.defaultMovie)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                            
                            VStack(alignment: .leading, content: {
                                Text(movie.title)
                                    .font(.title05)
                                    .foregroundColor(.black)
                                Text("\(movie.releaseDate)")
                                    .font(.body04)
                                    .foregroundColor(.black)
                                Spacer()
                                if let status = DBMovie.Status.getStatusByInt(movie.status) {
                                    switch status {
                                    case .bookmark:
                                        Text(status.statusString)
                                            .font(.caption01)
                                            .foregroundColor(.black)
                                    case .ing:
                                        if let start = movie.startDate {
                                            Text("\(start.yearMonthDay) ~ 보는 중")
                                                .font(.caption01)
                                                .foregroundColor(.black)
                                        }
                                    case .end:
                                        if let start = movie.startDate {
                                            if let end = movie.endDate {
                                                Text("\(start.yearMonthDay) ~ \(end.yearMonthDay) 다 봤어요")
                                                    .font(.caption01)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                }
                                
                            })
                            Spacer()
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            myMediaViewModel.isShowingDeleteAlert = true
                        } label: {
                            Text("삭제")
                        }
                        
                    }
                    .alert(isPresented: Binding<Bool>(
                        get: { myMediaViewModel.isShowingDeleteAlert },
                        set: { myMediaViewModel.isShowingDeleteAlert = $0 }
                    ), content: {
                        Alert(title: Text("나의 필모그래피에서 삭제하시겠습니까?"),
                              primaryButton: .destructive(Text("삭제") , action: {
                            myMediaViewModel.delMovie(movie: movie.toDBMovie())
                            dismiss()
                        }),
                              secondaryButton: .cancel(Text("취소"), action: {
                            myMediaViewModel.isShowingDeleteAlert = false
                        })
                        )
                    })
                }
                .refreshable {
                    myMediaViewModel.status = nil
                    myMediaViewModel.fetchAllMovie()
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
            }
        }
    }
    
    var filteringSection: some View {
        HStack {
            Button(action: {
                myMediaViewModel.status = nil
                myMediaViewModel.filterMovies(status: myMediaViewModel.status?.rawValue ?? -1)
            }, label: {
                Text("전체")
                    .font(.body01)
                    .padding(.top, 8)
                    .padding(.leading, 15)
                    .padding(.trailing, 14)
                    .padding(.bottom, 8)
            })
            .buttonStyle(.plain)
            .foregroundStyle(myMediaViewModel.status == nil ? Color.black : Color.gray)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(myMediaViewModel.status == nil ? Color.black : Color.gray, lineWidth: 1)
            )
            
            Button(action: {
                myMediaViewModel.status = .bookmark
                myMediaViewModel.filterMovies(status: DBMovie.Status.bookmark.rawValue)
            }, label: {
                Text(DBMovie.Status.bookmark.statusString)
                    .font(.body01)
                    .padding(.top, 8)
                    .padding(.leading, 15)
                    .padding(.trailing, 14)
                    .padding(.bottom, 8)
            })
            .buttonStyle(.plain)
            .foregroundStyle(myMediaViewModel.status == .bookmark ? Color.black : Color.gray)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(myMediaViewModel.status == .bookmark ? Color.black : Color.gray, lineWidth: 1)
            )
            
            Button(action: {
                myMediaViewModel.status = .ing
                myMediaViewModel.filterMovies(status: DBMovie.Status.ing.rawValue)
            }, label: {
                Text(DBMovie.Status.ing.statusString)
                    .font(.body01)
                    .padding(.top, 8)
                    .padding(.leading, 15)
                    .padding(.trailing, 14)
                    .padding(.bottom, 8)
            })
            .buttonStyle(.plain)
            .foregroundStyle(myMediaViewModel.status == .ing ? Color.black : Color.gray)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(myMediaViewModel.status == .ing ? Color.black : Color.gray, lineWidth: 1)
            )
            
            Button(action: {
                myMediaViewModel.status = .end
                myMediaViewModel.filterMovies(status: DBMovie.Status.end.rawValue)
            }, label: {
                Text(DBMovie.Status.end.statusString)
                    .font(.body01)
                    .padding(.top, 8)
                    .padding(.leading, 15)
                    .padding(.trailing, 14)
                    .padding(.bottom, 8)
            })
            .buttonStyle(.plain)
            .foregroundStyle(myMediaViewModel.status == .end ? Color.black : Color.gray)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(myMediaViewModel.status == .end ? Color.black : Color.gray, lineWidth: 1)
            )
        }
        .padding()
    }
}

#Preview {
    MyMediaView()
}
