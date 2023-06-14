//
//  SearchDetailButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import RealmSwift

struct SearchBookButtonsView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @ObservedResults(ReadingBook.self) var readingBooks
    
    @State private var isPresentingAddReadingBookView = false
    
    // MARK: - PROPERTIES
    
    let bookSearchInfo: detailBookInfo.Item
    @Binding var isLoadingCoverImage: Bool
    
    // MARK: - BODY
    
    var body: some View {
        bottomButtons
            .navigationDestination(isPresented: $isPresentingAddReadingBookView) {
                AddReadingBookView(bookSearchInfo)
            }
    }
    
    func isExistingReadingBook() -> Bool {
        for book in readingBooks where book.isbn13 == bookSearchInfo.isbn13 {
            return true
        }
        return false
    }
}

// MARK: - EXTENSIONS

extension SearchBookButtonsView {
    var bottomButtons: some View {
        VStack {
            bookAPIProviderText
            
            buttons
        }
    }
    
    var bookAPIProviderText: some View {
        HStack(spacing: 0) {
            Text("도서 DB 제공 : ")
            
            Link("알라딘 인터넷 서점", destination: URL(string: "https://www.aladin.co.kr")!)
                .disabled(isLoadingCoverImage)
        }
        .font(.caption)
        .redacted(reason: isLoadingCoverImage ? .placeholder : [])
        .shimmering(active: isLoadingCoverImage)
    }
    
    var buttons: some View {
        HStack {
            backButton
            
            readingBookAddButton
        }
        // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 0으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 20으로 설정
        .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
    }
    
    var backButton: some View {
        Group {
            if isExistingReadingBook() {
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
    
    var readingBookAddButton: some View {
        // 이미 목표 도서에 추가되어 있는 경우, 버튼 잠그기 (안 보이게 하기)
        Group {
            if !isExistingReadingBook() {
                NavigationLink {
                    AddReadingBookView(bookSearchInfo)
                } label: {
                    Text("추가하기")
                }
                .buttonStyle(RightBottomButtonStyle(backgroundColor: bookSearchInfo.bookCategory.themeColor))
                .disabled(isLoadingCoverImage)
            }
        }
    }
}

// MARK: - PREVIEW

struct SearchInfoButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookButtonsView(
            bookSearchInfo: detailBookInfo.Item.preview,
            isLoadingCoverImage: .constant(false)
        )
        .previewLayout(.sizeThatFits)
    }
}
