//
//  BookAddButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI
import RealmSwift

struct AddReadingBookButtonsView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var isPresentingAddReadingBookConfirmDialog = false
    
    // MARK: - PROPERTIES
    
    let searchBookInfo: detailBookInfo.Item
    @Binding var selectedDate: Date
    
    // MARK: - INTIALIZER
    
    init(_ searchBookInfo: detailBookInfo.Item, selectedDate: Binding<Date>) {
        self.searchBookInfo = searchBookInfo
        self._selectedDate = selectedDate
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            bookAPIProviderText
            
            buttons
        }
        .confirmationDialog("목표 도서에 추가하시겠습니까?",
                            isPresented: $isPresentingAddReadingBookConfirmDialog,
                            titleVisibility: .visible) {
            Button("확인") {
                let readingBook = ReadingBook(
                    value: [
                        "title": "\(searchBookInfo.title.refinedTitle)",
                        "author": "\(searchBookInfo.author.refinedAuthor)",
                        "publisher": "\(searchBookInfo.publisher)",
                        "pubDate": searchBookInfo.pubDate.refinedPublishDate,
                        "cover": "\(searchBookInfo.cover)",
                        "itemPage": searchBookInfo.subInfo.itemPage,
                        "category": searchBookInfo.categoryName.refinedCategory,
                        "introduction": searchBookInfo.description,
                        "link": "\(searchBookInfo.link)",
                        "isbn13": "\(searchBookInfo.isbn13)",
                        "startDate": Date(),
                        "targetDate": selectedDate,
                        "isCompleted": false
                    ] as [String : Any])
                realmManager.addReadingBook(readingBook)
                dismiss()
            }
            
            Button("취소", role: .cancel) {
                
            }
        }
        // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 0으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 20으로 설정
        .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
    }
}

extension AddReadingBookButtonsView {
    var bookAPIProviderText: some View {
        HStack(spacing: 0) {
            Text("도서 DB 제공 : ")
            
            Link("알라딘 인터넷 서점", destination: URL(string: "https://www.aladin.co.kr")!)
        }
        .font(.caption)
    }
    
    var buttons: some View {
        HStack {
            backButton
            
            addReadingBookButton
        }
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
        .buttonStyle(RightBottomButtonStyle(searchBookInfo.category.accentColor))
    }
}

// MARK: - PREVIEW

struct BookAddButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        AddReadingBookButtonsView(
            detailBookInfo.Item.preview[0],
            selectedDate: .constant(Date())
        )
        .environmentObject(RealmManager())
        .previewLayout(.sizeThatFits)
    }
}
