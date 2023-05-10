//
//  TargetBookDetailHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import SwiftUI
import RealmSwift

struct ReadingBookHeaderView: View {
    @Environment(\.dismiss) var dismiss
    
    let readingBook: ReadingBook
    @Binding var scrollYOffset: Double
    
    @State private var isPresentingDeleteConfirmationDialog = false
    
    var body: some View {
        HStack {
            Spacer()
            
            navigationTitle
            
            Spacer()
        }
        .overlay {
            navigationBarItems
        }
        .confirmationDialog("도서를 삭제하시겠습니까?", isPresented: $isPresentingDeleteConfirmationDialog, titleVisibility: .visible, actions: {
            Button("삭제", role: .destructive) {
                RealmManager.shared.deleteReadingBook(readingBook.isbn13)
                dismiss()
            }
        })
        .padding(.vertical)
    }
}

extension ReadingBookHeaderView {
    var navigationTitle: some View {
        Group {
            if scrollYOffset > 30 {
                Text(readingBook.title)
                    .frame(width: mainScreen.width * 0.65)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .navigationTitleStyle()
            } else {
                Text("도서 정보")
                    .navigationTitleStyle()
            }
        }
    }
    
    var navigationBarItems: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .navigationBarItemStyle()
            }
            
            Spacer()
            
            Menu {
                Section {
                    Button {
                        // do something...
                    } label: {
                        Label("편집", systemImage: "square.and.pencil")
                    }

                    Button(role: .destructive) {
                        isPresentingDeleteConfirmationDialog = true
                    } label: {
                        Label("삭제", systemImage: "trash")
                    }
                } header: {
                    Text("도서 편집")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .navigationBarItemStyle()
            }
        }
    }
}

struct TargetBookDetailHeaderView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var completeTargetBooks
    
    static var previews: some View {
        ReadingBookHeaderView(readingBook: completeTargetBooks[0], scrollYOffset: .constant(0.0))
    }
}
