//
//  BookAddButtonsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/17.
//

import SwiftUI
import RealmSwift

struct BookAddButtonsView: View {
    
    let bookInfoItem: BookInfo.Item
    @Binding var selectedDate: Date
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedResults(ReadingBook.self) var completeTargetBooks
    
    @State private var isPresentingDateDescSheet = false
    @State private var isPresentingConfirmDialog = false
    
    var body: some View {
        VStack {
            howToCalculateTimeButton
            
            bottomButtons
        }
        .confirmationDialog("목표 도서에 추가하시겠습니까?", isPresented: $isPresentingConfirmDialog, titleVisibility: .visible) {
            Button("확인") {
                let completeTargetBook = ReadingBook(
                    value: [
                        "title": "\(bookInfoItem.title.refinedTitle)",
                        "author": "\(bookInfoItem.author.refinedAuthor)",
                        "publisher": "\(bookInfoItem.publisher)",
                        "pubDate": bookInfoItem.pubDate.refinedPublishDate,
                        "cover": "\(bookInfoItem.cover)",
                        "itemPage": bookInfoItem.subInfo.itemPage,
                        "category": bookInfoItem.categoryName.refinedCategory,
                        "link": "\(bookInfoItem.link)",
                        "isbn13": "\(bookInfoItem.isbn13)",
                        "startDate": Date(),
                        "targetDate": selectedDate,
                        "isCompleted": false
                    ] as [String : Any])
                RealmManager.shared.addReadingBook(completeTargetBook)
                
                dismiss()
            }
            
            Button("취소", role: .cancel) {
                
            }
        }
        .sheet(isPresented: $isPresentingDateDescSheet) {
            DateDescSheetView(bookInfo: bookInfoItem)
        }
        .padding(.horizontal)
        // 베젤이 없는 아이폰(iPhone 14 등)은 하단 간격 0으로 설정
        // 베젤이 있는 아이폰(iPhone SE 등)은 하단 간격 20으로 설정
        .padding(.bottom, safeAreaInsets.bottom != 0 ? 0 : 20)
    }
}

extension BookAddButtonsView {
    var howToCalculateTimeButton: some View {
        Button {
            isPresentingDateDescSheet = true
        } label: {
            Text("날짜 계산은 어떻게 하나요?")
                .font(.caption)
        }
        .padding(.top, 10)
    }
    
    var bottomButtons: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                backLabel
            }
            
            Button {
                isPresentingConfirmDialog = true
            } label: {
                addLabel
            }
        }
        .padding(.horizontal)
    }
    
    var backLabel: some View {
        Text("돌아가기")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.2))
            .cornerRadius(15)
    }
    
    var addLabel: some View {
        Text("추가하기")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(bookInfoItem.categoryName.refinedCategory.accentColor)
            .cornerRadius(15)
    }
}

struct BookAddButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        BookAddButtonsView(bookInfoItem: BookInfo.Item.preview[0], selectedDate: .constant(Date()))
    }
}
