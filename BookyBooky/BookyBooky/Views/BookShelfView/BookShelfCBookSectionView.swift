//
//  BookShelfCompBookTabView.swift
//  BookyBooky
//
//  Created by 김건우 on 6/17/23.
//

import SwiftUI
import RealmSwift

struct BookShelfCBookSectionView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @ObservedResults(CompleteBook.self) var completeBooks
    
    @State private var isPresentingCompleteBookListView = false
    
    // MARK: - PROPERTIES
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - BODY
    
    var body: some View {
        Section {
            let completeBooks = completeBooks.get(of: .complete)
            if completeBooks.isEmpty {
                noBooksLabel
            } else {
                scrollContent
            }
        } header: {
            tabTitle
        }
        .sheet(isPresented: $isPresentingCompleteBookListView) {
            BookShelfListView(type: .complete)
        }
    }
}

// MARK: - EXTENSION

extension BookShelfCBookSectionView {
    var scrollContent: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            let completeBooks = completeBooks.get(of: .complete)
            ForEach(completeBooks, id: \.self) { book in
                HomeReadingBookButton(book)
                    .padding(.top, 10)
            }
        }
        .padding()
        .padding(.bottom, 20)
    }
    
    var noBooksLabel: some View {
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
    
    var tabTitle: some View {
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
            .disabled(completeBooks.get(of: .complete).isEmpty)
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

struct BookShelfCBookSectionView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfCBookSectionView()
    }
}
