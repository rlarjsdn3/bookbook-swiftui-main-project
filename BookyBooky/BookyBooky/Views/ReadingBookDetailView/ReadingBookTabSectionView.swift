//
//  ReadingBookTabSectionView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/03.
//

import SwiftUI

struct ReadingBookTabSectionView: View {
    @Binding var selectedTab: ReadingBookTabItems
    @Binding var selectedAnimation: ReadingBookTabItems
    @Binding var scrollYOffset: Double
    let underlineAnimation: Namespace.ID
    
    var body: some View {
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
                ForEach(ReadingBookTabItems.allCases, id: \.self) { item in
                    Spacer()
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
                    Spacer()
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
    }
}

struct ReadingBookTabSectionView_Previews: PreviewProvider {
    @Namespace static var underlineAnimation
    
    static var previews: some View {
        ReadingBookTabSectionView(selectedTab: .constant(.overview), selectedAnimation: .constant(.overview), scrollYOffset: .constant(0.0), underlineAnimation: underlineAnimation)
    }
}
