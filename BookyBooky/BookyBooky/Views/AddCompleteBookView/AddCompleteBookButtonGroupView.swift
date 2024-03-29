//
//  BookAddButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI
import RealmSwift

struct AddCompleteBookButtonGroupView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var addCompleteBookViewData: AddCompleteBookViewData
    
    @State private var isPresentingAddReadingBookConfirmDialog = false
    
    // MARK: - PROPERTIES
    
    let book: DetailBookInfo.Item
    
    // MARK: - INTIALIZER
    
    init(_ book: DetailBookInfo.Item) {
        self.book = book
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

extension AddCompleteBookButtonGroupView {
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
        .buttonStyle(RightBottomButtonStyle(backgroundColor: book.bookCategory.themeColor))
    }
    
    var okButton: some View {
        Button("확인") {
            let readingBook = CompleteBook(
                value: [
                    "title": "\(book.title.refinedTitle)",
                    "author": "\(book.author.refinedAuthor)",
                    "publisher": "\(book.publisher)",
                    "pubDate": book.pubDate.refinedPublishDate,
                    "cover": "\(book.cover)",
                    "itemPage": book.subInfo.itemPage,
                    "category": book.categoryName.refinedCategory,
                    "desc": book.description,
                    "link": "\(book.link)",
                    "isbn13": "\(book.isbn13)",
                    "startDate": Date(),
                    "targetDate": addCompleteBookViewData.selectedTargetDate,
                    "isCompleted": false
                ] as [String : Any])
            realmManager.addReadingBook(readingBook)
            alertManager.isPresentingReadingBookAddSuccessToastAlert = true
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
        AddCompleteBookButtonGroupView(DetailBookInfo.Item.preview)
            .environmentObject(RealmManager())
            .environmentObject(AlertManager())
            .environmentObject(AddCompleteBookViewData())
    }
}
