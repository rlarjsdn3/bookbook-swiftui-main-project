//
//  HomeScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/20.
//

import SwiftUI
import SwiftDate
import RealmSwift

struct HomeScrollView: View {
    @ObservedResults(CompleteTargetBook.self) var completeTargetBooks
    
    @State private var startOffset = 0.0
    @Binding var scrollYOffset: Double
    
    var categories: [Category] {
        var categories: [Category] = [.all]
        
        for book in completeTargetBooks where !categories.contains(book.category) {
            categories.append(book.category)
        }
        
        return categories
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                VStack(alignment: .leading) {
                    Text(Date().toFormat("M월 dd일 EEEE", locale: Locale(identifier: "ko")))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .opacity(scrollYOffset > 10 ? 0 : 1)
                    
                    Text("홈")
                        .font(.system(size: 34 + getFontSizeOffset()))
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.001)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                
                Text("활동")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.bottom, -5)
                    .padding(.top, 1)
                
                ScrollView {
                    Text("UI 미완성")
                        .font(.title3)
                        .padding()
                        .background(.gray.opacity(0.3))
                        .cornerRadius(15)
                        .shimmering()
                        .padding(.vertical, 25)
                }
                
                HStack {
                    Text("독서")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                        .padding(.bottom, -5)
                        .padding(.top, 1)
                    
                    Menu {
                        Button("최근 읽은 순") {
                            
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .navigationBarItemStyle()
                }
                
                
                Section {
                    ForEach(completeTargetBooks) { targetBook in
                        Text("\(targetBook.title)")
                    }
                } header: {
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(categories, id: \.self) { category in
                                    Button {
                                        
                                    } label: {
                                        Text(category.rawValue)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .overlay(alignment: .bottomLeading) {
                                                Rectangle()
                                                    .frame(width: 40, height: 1)
                                                    .offset(y: 9)
                                            }
                                            .padding(.horizontal)
                                    }
                                    .foregroundColor(.black)

                                }
                            }
                            .padding(.vertical, 9)
                            .background(.white)
                        }
                    }
                    .background(.white)
                }
                .overlay(alignment: .bottom) {
                    Divider()
                        .opacity(scrollYOffset > 30 ? 1 : 0)
                }
            }
            .overlay(alignment: .top) {
                GeometryReader { proxy -> Color in
                    DispatchQueue.main.async {
                        let offset = proxy.frame(in: .global).minY
                        if startOffset == 0 {
                            self.startOffset = offset
                        }
                        withAnimation(.easeInOut(duration: 0.1)) {
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

extension HomeScrollView {
    
}

struct HomeScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScrollView(scrollYOffset: .constant(0.0))
    }
}
