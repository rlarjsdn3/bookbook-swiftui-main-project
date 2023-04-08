//
//  BookShelfScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/08.
//

import SwiftUI

struct BookShelfScrollView: View {
    @State private var startOffset: CGFloat = 0.0
    @Binding var scrollYOffset: CGFloat
    
    @Namespace var selectedNamespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Text("책장")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Section {
                    ZStack {
                        Color("Background")
                        
                        VStack {
                            ForEach(1..<100) { index in
                                Text("\(index)")
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("찜한 도서")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("자세히 보기")
                        }

                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .opacity(scrollYOffset > 70.0 ? 1 : 0)
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
}

struct BookShelfScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfScrollView(scrollYOffset: .constant(0.0))
    }
}

/*

struct SearchListTypeView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var selectedAnimation = BookListTabItem.bestSeller
    
    @Binding var listTypeSelected: BookListTabItem
    @Namespace var namespace: Namespace.ID
    
    // MARK: - BODY
    
    var body: some View {
        ScrollViewReader { proxy in
            scrollListTypeButtons(scrollProxy: proxy)
        }
    }
}

// MARK: - EXTENSIONS

extension SearchListTypeView {
    @ViewBuilder
    func scrollListTypeButtons(scrollProxy proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            listTypeButtons(scrollProxy: proxy)
        }
    }
    
    @ViewBuilder
    func listTypeButtons(scrollProxy proxy: ScrollViewProxy) -> some View {
        HStack {
            ForEach(BookListTabItem.allCases, id: \.self) { type in
                ListTypeButtonView(
                    listTypeSelected: $listTypeSelected,
                    type: type,
                    scrollProxy: proxy,
                    selectedAnimation: $selectedAnimation,
                    selectedNamespace: namespace
                )
                .padding(.horizontal, 8)
                .id(type.rawValue)
            }
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
}

*/
