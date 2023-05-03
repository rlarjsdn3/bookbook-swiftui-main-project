//
//  ReadingBookDetailScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI
import RealmSwift

struct ReadingBookScrollView: View {
    @State private var startOffset = 0.0
    
    @Binding var scrollYOffset: Double
    @Binding var selectedTab: ReadingBookDetailTabItems
    @Binding var selectedAnimation: ReadingBookDetailTabItems
    
    @Namespace var underlineAnimation
    
    let readingBook: ReadingBook
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ReadingBookCoverView(readingBook: readingBook)
                
                ReadingBookRenewalButtonView(readingBook: readingBook)
                
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
                        ForEach(ReadingBookDetailTabItems.allCases, id: \.self) { item in
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
}

struct ReadingBookDetailScrollView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookScrollView(scrollYOffset: .constant(0.0), selectedTab: .constant(.overview), selectedAnimation: .constant(.overview), readingBook: readingBooks[0])
    }
}
