//
//  HomeTargetBookDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct ReadingBookDetailView: View {
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var startOffset = 0.0
    @State private var scrollYOffset = 0.0
    
    @State private var selectedTab: TargetBookDetailTabItems = .overview
    @State private var selectedAnimation: TargetBookDetailTabItems = .overview
    
    @Namespace var underlineAnimation
    
    var body: some View {
        //  도서 삭제 시, 책 제목/저자 등 정보가 사라지지 않게 하기 (추후 수정 예정)
        
        VStack(spacing: 0) {
            ReadingBookDetailHeaderView(targetBook: readingBook, scrollYOffset: $scrollYOffset)
            
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    ReadingBookDetailCoverView(readingBook: readingBook)
                    
                    HStack {
                        Button {
                            // do something...
                        } label: {
                            Text("읽었어요!")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 112, height: 30)
                                .background(.gray.opacity(0.3))
                                .clipShape(Capsule())
                        }
                        
                        // 코드 미완성
                        Text("\(Text("목표 기한: ").fontWeight(.bold)) \(readingBook.targetDate.toFormat("yyyy년 M월 d일")) (7일 남음)")
                            .font(.caption.weight(.light))
                            .padding(.horizontal)
                        
    
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal, .bottom])
                    
                    Section {
                        ForEach(0..<10) { index in
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
                            ForEach(TargetBookDetailTabItems.allCases, id: \.self) { item in
                                Button {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                        selectedAnimation = item
//                                                scrollProxy.scrollTo("Scroll_To_Category", anchor: .top)
//                                                scrollProxy.scrollTo("\(category.rawValue)")
                                    }
                                    selectedTab = item
                                } label: {
                                    Text(item.name)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(selectedAnimation == item ? .black : .gray)
                                        .overlay(alignment: .bottomLeading) {
                                            if selectedAnimation == item {
                                                Rectangle()
                                                    .offset(y: 15)
                                                    .fill(.black)
                                                    .frame(width: 40, height: 1)
                                                    .matchedGeometryEffect(id: "underline", in: underlineAnimation)
                                            }
                                        }
                                        .padding(.horizontal, 10)
                                }
                                .padding(.vertical, 10)
                                .padding([.horizontal, .bottom], 5)
                                .id("\(item.name)")
                            }
                            .id("Scroll_To_Category")
                        }
                        .background(.white)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .bottom) {
                            Divider()
                                .opacity(scrollYOffset > 30 ? 1 : 0)
                        }
                    }

                    
                    Spacer()
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
        .navigationBarBackButtonHidden()
    }
}

extension ReadingBookDetailView {
    
}

struct HomeTargetBookDetailView_Previews: PreviewProvider {
    static let realmManager = RealmManager.openLocalRealm()
    @ObservedResults(ReadingBook.self) static var completeTargetBooks
    
    static var previews: some View {
        ReadingBookDetailView(readingBook: completeTargetBooks[0])
    }
}
