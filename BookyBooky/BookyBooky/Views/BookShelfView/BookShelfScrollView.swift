//
//  BookShelfScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI
import RealmSwift

struct BookShelfScrollView: View {
    
    @ObservedResults(FavoriteBook.self) var favoriteBooks
    
    
    // 열거형으로 리팩토링하기
    let labelTitle = ["읽은 도서 수", "찜한 도서 수", "수집 문장 수"]
    let systemImages = ["book", "heart.fill", "bookmark.fill"]
    let imageColors = [Color.blue, Color.pink, Color.green]
    
    
    @State private var tapISBN13 = ""
    @State private var showFavoriteBookInfo = false
    @State private var startOffset: CGFloat = 0.0
    @Binding var scrollYOffset: CGFloat
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Text("책장")
                    .font(.system(size: 34 + getFontSizeOffset()))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .minimumScaleFactor(0.001)
                    .padding(.horizontal)
                
                HStack {
//                    Spacer(minLength: 0)
                    
                    
                    VStack {
                        HStack {
                            ForEach(0..<3) { index in
                                Spacer()
                                Image(systemName: systemImages[index])
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .background {
                                        Circle()
                                            .fill(imageColors[index].gradient)
                                            .frame(width: 70, height: 70)
                                    }
                                    .padding(10)
                                Spacer()
                            }
                        }
                        
                        HStack {
                            ForEach(0..<3) { index in
                                Spacer()
                                Text(labelTitle[index])
                                    .fontWeight(.bold)
                                    .padding(.vertical, 8)
                                Spacer()
                            }
                        }
                        
                        HStack {
                            ForEach(0..<3) { index in
                                Spacer()
                                switch labelTitle[index] {
                                case "찜한 도서 수":
                                    Text("\(favoriteBooks.count)")
                                        .font(.title2)
                                default:
                                    Text("0")
                                        .font(.title2)
                                }
                                Spacer()
                            }
                            .padding(.top, -13)
                        }
                    }
                    
//                    ForEach(0..<3) { index in
//                        Spacer(minLength: 0)
//                        VStack {
//                            Image(systemName: systemImages[index])
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                                .background {
//                                    Circle()
//                                        .fill(imageColors[index].gradient)
//                                        .frame(width: 70, height: 70)
//                                }
//                                .padding(10)
//
//                            Spacer(minLength: 10)
//
//                            Text(labelTitle[index])
//                                .fontWeight(.semibold)
//                                .padding(.vertical, 4)
//
//                            Spacer(minLength: 0)
//
//                            Text("0")
//                                .font(.title)
//                        }
//                        .offset(y: index == 2 ? -2 : 0)
//
//
//                        Spacer(minLength: 0)
//                    }
//
//                    Spacer(minLength: 0)
//
//                    VStack {
//                        Image(systemName: "heart.fill")
//                            .font(.largeTitle)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background {
//                                Circle()
//                                    .fill(.pink.gradient)
//                        }
//
//                        Text("찜한 도서 수")
//                            .fontWeight(.semibold)
//                            .frame(height: 30)
//
//                        Text("\(favoriteBooks.count)")
//                            .font(.title)
//                    }
//
//                    Spacer(minLength: 0)
//
//                    VStack {
//                        Image(systemName: "text.book.closed.fill")
//                            .font(.largeTitle)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background {
//                                Circle()
//                                    .fill(.green.gradient)
//                        }
//
//                        Text("수집 문장 수")
//                            .fontWeight(.semibold)
//                            .frame(height: 30)
//
//                        Text("0")
//                            .font(.title)
//                    }
                    
//                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 30)
                
                Section {
                    if !favoriteBooks.isEmpty {
                        scrollFavoriteBooks
                    } else {
                        Text("찜한 도서가 없음")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 30)
                    }
                } header: {
                    HStack {
                        Text("찜한 도서")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("자세히 보기")
                        }
                        .disabled(favoriteBooks.isEmpty)

                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .opacity(scrollYOffset > 70.0 ? 1 : 0)
                    }
                }
                
                Section {
                    ForEach(1..<100) { index in
                        Text("UI 미완성")
                            .font(.title3)
                            .padding()
                            .background(.gray.opacity(0.3))
                            .cornerRadius(15)
                            .shimmering()
                            .padding(.vertical, 25)
                    }
                } header: {
                    HStack {
                        Text("읽은 도서")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .opacity(!favoriteBooks.isEmpty ? scrollYOffset > 410.0 ? 1 : 0 : scrollYOffset > 245.0 ? 1 : 0)
                    }
                }
            }
            .overlay(alignment: .top) {
                GeometryReader { proxy -> Color in
                    DispatchQueue.main.async {
                        let offset = proxy.frame(in: .global).minY
                        if startOffset == 0 {
                            self.startOffset = offset
                        }
                        withAnimation(.easeInOut(duration: 0.2)) {
                            scrollYOffset = startOffset - offset
                        }
                        print(scrollYOffset)
                    }
                    return Color.clear
                }
                .frame(width: 0, height: 0)
            }
        }
    }
    
    /// 스크롤의 최상단 Y축 좌표의 위치에 따라 폰트의 추가 사이즈를 반환하는 함수입니다.
    func getFontSizeOffset() -> CGFloat {
        let START_yOFFSET = 20.0 // 폰트 크기가 커지기 시작하는 Y축 좌표값
        let END_yOFFSET = 130.0  // 폰트 크기가 최대로 커진 Y축 좌표값
        let SCALE = 0.03         // Y축 좌표값에 비례하여 커지는 폰트 크기의 배수
        
        // Y축 좌표가 START_yOFFSET 이상이라면
        if -scrollYOffset > START_yOFFSET {
            // Y축 좌표가 END_yOFFSET 미만이라면
            if -scrollYOffset < END_yOFFSET {
                return -scrollYOffset * SCALE // 현재 최상단 Y축 좌표의 SCALE배만큼 추가 사이즈 반환
            // Y축 좌표가 END_yOFFSET 이상이면
            } else {
                return END_yOFFSET * SCALE // 폰트의 최고 추가 사이즈 반환
            }
        }
        // Y축 좌표가 START_yOFFSET 미만이라면
        return 0.0 // 폰트 추가 사이즈 없음
    }
}

extension BookShelfScrollView {
    var scrollFavoriteBooks: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(favoriteBooks.reversed()) { favoriteBook in
                    FavoriteBookCellView(favoriteBook: favoriteBook)
                  
                }
            }
        }
        .padding(.horizontal, 3)
    }
}

struct BookShelfScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfScrollView(scrollYOffset: .constant(0.0))
    }
}
