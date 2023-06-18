//
//  BookShelfSentenceFilterSheetView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/03.
//

import SwiftUI
import RealmSwift

// 도서 리팩토링하기

struct BookShelfSentenceFilterSheetView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedResults(CompleteBook.self) var readingBooks
    
    @State private var unselectedFilterBook: [String] = []
    
    @Binding var selectedFilterBook: [String]
    
    let columns: [GridItem] = [
        .init(.flexible()),
        .init(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    Text("필터 도서")
                        .font(.title3.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    HStack {
                        if selectedFilterBook.isEmpty {
                            Text("전체")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.black)
                                .cornerRadius(20)
                                .padding(.horizontal)
                        } else {
                            LazyVGrid(columns: columns) {
                                ForEach(selectedFilterBook, id: \.self) { book in
                                    Button {
                                        if let index = selectedFilterBook.firstIndex(of: book) {
                                            selectedFilterBook.remove(at: index)
                                            unselectedFilterBook.append(book)
                                        }
                                        HapticManager.shared.impact(.rigid)
                                    } label: {
                                        Text(book)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .truncationMode(.middle)
                                            .foregroundColor(Color.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(Color.black)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 15)
                    
                    //
                    
                    Text("도서 목록")
                        .font(.title3.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    LazyVGrid(columns: columns) {
                        ForEach(unselectedFilterBook, id: \.self) { readingBook in
                            Button {
                                if let index = unselectedFilterBook.firstIndex(of: readingBook) {
                                    selectedFilterBook.append(readingBook)
                                    unselectedFilterBook.remove(at: index)
                                }
                                HapticManager.shared.impact(.rigid)
                            } label: {
                                HStack {
                                    Text(readingBook)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                        .foregroundColor(Color.black)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Color.background)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("적용하기")
                }
                .buttonStyle(BottomButtonStyle(backgroundColor: Color.black))
            }
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            selectedFilterBook.removeAll()
                            
                            for readingBook in readingBooks {
                                if !unselectedFilterBook.contains(where: { $0 == readingBook.title }) {
                                    unselectedFilterBook.append(readingBook.title)
                                }
                            }
                        }
                    } label: {
                        Text("전체")
                    }
                    .disabled(selectedFilterBook.isEmpty)
                }
            }
            .navigationTitle("도서 필터링하기")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            readingBooks.forEach { book in
                if !selectedFilterBook.contains(where: { $0 == book.title }) {
                    unselectedFilterBook.append(book.title)
                }
            }
        }
        .presentationCornerRadius(30)
    }
}

struct BookShelfSentenceFilterSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfSentenceFilterSheetView(selectedFilterBook: .constant([""]))
    }
}
