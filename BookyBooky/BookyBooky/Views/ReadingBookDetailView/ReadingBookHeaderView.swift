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
    
    @EnvironmentObject var realmManager: RealmManager
    
    @ObservedRealmObject var readingBook: ReadingBook
    @Binding var scrollYOffset: Double
    
    @State private var isPresentingEditBookInformationSheet = false
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
        .sheet(isPresented: $isPresentingEditBookInformationSheet) {
            EditBookInformationView(readingBook: readingBook)
        }
        .confirmationDialog("도서를 삭제하시겠습니까?", isPresented: $isPresentingDeleteConfirmationDialog, titleVisibility: .visible) {
            Button("삭제", role: .destructive) {
                dismiss()
                realmManager.deleteReadingBook(readingBook.isbn13)
            }
        }
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
                        
                    } label: {
                        Label("문장 추가", systemImage: "bookmark.fill")
                    }

                    
                    Divider()
                    
                    Button {
                        isPresentingEditBookInformationSheet = true
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
    static var previews: some View {
        ReadingBookHeaderView(readingBook: ReadingBook.preview, scrollYOffset: .constant(0.0))
            .environmentObject(RealmManager())
    }
}
