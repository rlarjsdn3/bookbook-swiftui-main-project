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
    @ObservedResults(CompleteBook.self) var compBooks
    
    @State private var isPresentingAddReadingBookView = false
    
    // MARK: - PROPERTIES
    
    let bookItem: detailBookInfo.Item
    @Binding var isLoadingCoverImage: Bool
    
    // MARK: - INTIALIZER
    
    init(_ bookItem: detailBookInfo.Item, isLoadingCoverImage: Binding<Bool>) {
        self.bookItem = bookItem
        self._isLoadingCoverImage = isLoadingCoverImage
    }
    
    // MARK: - BODY
    
    var body: some View {
        ButtonGroup
    }
    
    func isExist() -> Bool {
        for book in compBooks where book.isbn13 == bookItem.isbn13 {
            return true
        }
        return false
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
                .disabled(isLoadingCoverImage)
        }
        .font(.caption)
        .redacted(reason: isLoadingCoverImage ? .placeholder : [])
        .shimmering(active: isLoadingCoverImage)
    }
    
    var backButton: some View {
        Group {
            if isExist() {
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
            if !isExist() {
                NavigationLink {
                    AddReadingBookView(bookItem)
                } label: {
                    Text("추가하기")
                }
                .buttonStyle(RightBottomButtonStyle(backgroundColor: bookItem.bookCategory.themeColor))
                .disabled(isLoadingCoverImage)
            }
        }
    }
}

// MARK: - PREVIEW

struct SearchInfoButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookButtonGroupView(
            detailBookInfo.Item.preview,
            isLoadingCoverImage: .constant(false)
        )
        .previewLayout(.sizeThatFits)
    }
}
