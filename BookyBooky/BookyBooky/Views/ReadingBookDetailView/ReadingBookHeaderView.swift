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
    
    @ObservedResults(ReadingBook.self) var completeTargetBooks
    
    let targetBook: ReadingBook
    @Binding var scrollYOffset: Double
    
    @State var title: String = ""
    
    var body: some View {
        HStack {
            Spacer()
            
            navigationTitle
            
            Spacer()
        }
        .overlay {
            navigationBarItems
        }
        .onAppear {
            title = targetBook.title
        }
        .padding(.vertical)
    }
}

extension ReadingBookHeaderView {
    var navigationTitle: some View {
        Group {
            if scrollYOffset > 30 {
                Text(title)
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
                        RealmManager.shared.deleteReadingBook(targetBook.isbn13)
                        dismiss()
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
        ReadingBookHeaderView(targetBook: completeTargetBooks[0], scrollYOffset: .constant(0.0))
    }
}
