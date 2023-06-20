//
//  BookAddButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI
import RealmSwift

struct AddReadingBookButtonGroupView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var isPresentingAddReadingBookConfirmDialog = false
    
    // MARK: - PROPERTIES
    
    let bookItem: detailBookInfo.Item
    @Binding var selectedDate: Date
    
    // MARK: - INTIALIZER
    
    init(_ bookItem: detailBookInfo.Item, selectedDate: Binding<Date>) {
        self.bookItem = bookItem
        self._selectedDate = selectedDate
    }
    
    // MARK: - BODY
    
    var body: some View {
        buttonGroup
            .confirmationDialog("목표 도서로 추가하시겠습니까?",
                                isPresented: $isPresentingAddReadingBookConfirmDialog,
                                titleVisibility: .visible) {
                okButton
                
                cancelButton
            }
            // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 0으로 설정
            // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 20으로 설정
            .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
    }
}

extension AddReadingBookButtonGroupView {
    var buttonGroup: some View {
        VStack {
            dbProviderLabel
            
            HStack {
                backButton
                
                addReadingBookButton
            }
        }
    }
    
    var dbProviderLabel: some View {
        HStack(spacing: 0) {
            Text("도서 DB 제공 : ")
            
            Link("알라딘 인터넷 서점", destination: URL(string: "https://www.aladin.co.kr")!)
        }
        .font(.caption)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Text("돌아가기")
        }
        .buttonStyle(.leftBottomButtonStyle)
    }
    
    var addReadingBookButton: some View {
        Button {
            isPresentingAddReadingBookConfirmDialog = true
        } label: {
            Text("추가하기")
        }
        .buttonStyle(RightBottomButtonStyle(backgroundColor: bookItem.bookCategory.themeColor))
    }
    
    var okButton: some View {
        Button("확인") {
            let readingBook = CompleteBook(
                value: [
                    "title": "\(bookItem.title.refinedTitle)",
                    "author": "\(bookItem.author.refinedAuthor)",
                    "publisher": "\(bookItem.publisher)",
                    "pubDate": bookItem.pubDate.refinedPublishDate,
                    "cover": "\(bookItem.cover)",
                    "itemPage": bookItem.subInfo.itemPage,
                    "category": bookItem.categoryName.refinedCategory,
                    "introduction": bookItem.description,
                    "link": "\(bookItem.link)",
                    "isbn13": "\(bookItem.isbn13)",
                    "startDate": Date(),
                    "targetDate": selectedDate,
                    "isCompleted": false
                ] as [String : Any])
            realmManager.addReadingBook(readingBook)
            dismiss()
        }
    }
    
    var cancelButton: some View {
        Button("취소", role: .cancel) { }
    }
}

// MARK: - PREVIEW

struct BookAddButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        AddReadingBookButtonGroupView(
            detailBookInfo.Item.preview,
            selectedDate: .constant(Date())
        )
        .environmentObject(RealmManager())
        .previewLayout(.sizeThatFits)
    }
}
