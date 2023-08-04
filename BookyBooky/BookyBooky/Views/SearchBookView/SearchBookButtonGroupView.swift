//
//  SearchDetailButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import RealmSwift

struct SearchBookButtonGroupView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var searchBookViewData: SearchBookViewData
    
    @ObservedResults(CompleteBook.self) var completeBooks
    
    @State private var isPresentingAddReadingBookView = false
    
    // MARK: - PROPERTIES
    
    let book: DetailBookInfo.Item
    
    // MARK: - COMPUTED PROPERTIES
    
    var isAlreadyExistBook: Bool {
        for cBook in completeBooks where book.isbn13 == cBook.isbn13 {
            return true
        }
        return false
    }
    
    // MARK: - INTIALIZER
    
    init(_ bookItem: DetailBookInfo.Item) {
        self.book = bookItem
    }
    
    // MARK: - BODY
    
    var body: some View {
        ButtonGroup
    }
}

// MARK: - EXTENSIONS

extension SearchBookButtonGroupView {
    var ButtonGroup: some View {
        VStack {
            dbProviderText
            
            HStack {
                backButton
                
                addButton
            }
            // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 0으로 설정
            // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 20으로 설정
            .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
        }
    }
    
    var dbProviderText: some View {
        HStack(spacing: 0) {
            Text("도서 DB 제공 : ")
            
            Link("알라딘 인터넷 서점", destination: URL(string: "https://www.aladin.co.kr")!)
                .disabled(searchBookViewData.isLoadingCoverImage)
        }
        .font(.caption)
        .redacted(reason: searchBookViewData.isLoadingCoverImage ? .placeholder : [])
        .shimmering(active: searchBookViewData.isLoadingCoverImage)
    }
    
    var backButton: some View {
        Group {
            if isAlreadyExistBook {
                Button {
                    dismiss()
                } label: {
                    Text("돌아가기")
                }
                .buttonStyle(BottomButtonStyle())
            } else {
                Button {
                    dismiss()
                } label: {
                    Text("돌아가기")
                }
                .buttonStyle(LeftBottomButtonStyle())
            }
        }
    }
    
    var addButton: some View {
        // 이미 목표 도서에 추가되어 있는 경우, 버튼 잠그기 (안 보이게 하기)
        Group {
            if !isAlreadyExistBook {
                NavigationLink {
                    AddCompleteBookView(book)
                } label: {
                    Text("추가하기")
                }
                .buttonStyle(RightBottomButtonStyle(backgroundColor: book.bookCategory.themeColor))
                .disabled(searchBookViewData.isLoadingCoverImage)
            }
        }
    }
}

// MARK: - PREVIEW

struct SearchInfoButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookButtonGroupView(DetailBookInfo.Item.preview)
            .environmentObject(SearchBookViewData())
    }
}
