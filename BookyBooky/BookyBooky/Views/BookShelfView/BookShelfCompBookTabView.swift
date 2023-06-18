//
//  BookShelfCompBookTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/17/23.
//

import SwiftUI
import RealmSwift

struct BookShelfCompBookTabView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    @State private var isPresentingCompleteBookListView = false
    
    // MARK: - PROPERTIES
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - BODY
    
    var body: some View {
        compBookTab
            .sheet(isPresented: $isPresentingCompleteBookListView) {
                BookShelfListView(type: .complete)
            }
    }
}

// MARK: - EXTENSION

extension BookShelfCompBookTabView {
    var compBookTab: some View {
            Section {
                if readingBooks.get(.complete).isEmpty {
                    noCompleteBooksLabel
                } else {
                    compBookScrollContent
                }
            } header: {
                compBookHeaderLabel
            }
    }
    
    var compBookScrollContent: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(readingBooks.get(.complete), id: \.self) { book in
                ReadingBookButton(book, type: .shelf)
                    .padding(.top, 10)
            }
        }
        .padding()
    }
    
    var noCompleteBooksLabel: some View {
        VStack(spacing: 5) {
            Text("읽은 도서가 없음")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("독서를 시작해보세요.")
                .foregroundColor(.secondary)
        }
        .padding(.top, 50)
        .padding(.bottom, 200) // 임시
    }
    
    var compBookHeaderLabel: some View {
        HStack {
            Text("읽은 도서")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                isPresentingCompleteBookListView = true
            } label: {
                Text("더 보기")
            }
            .disabled(readingBooks.get(.complete).isEmpty)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .padding(.bottom, 5)
        .padding(.horizontal)
        .background(.white)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

// MARK: - PREVIEW

#Preview {
    BookShelfCompBookTabView()
}
