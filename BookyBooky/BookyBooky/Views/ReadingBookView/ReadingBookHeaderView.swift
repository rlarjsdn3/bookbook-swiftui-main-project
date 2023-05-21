//
//  TargetBookDetailHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import SwiftUI
import RealmSwift

struct ReadingBookHeaderView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var isPresentingEditBookInformationSheet = false
    @State private var isPresentingDeleteConfirmationDialog = false
    
    // MARK: - PROPERTIES
    
    @ObservedRealmObject var readingBook: ReadingBook
    @Binding var scrollYOffset: Double
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook, scrollYOffset: Binding<Double>) {
        self.readingBook = readingBook
        self._scrollYOffset = scrollYOffset
    }
    
    // MARK: - BODY
    
    var body: some View {
        navigationBar
            .sheet(isPresented: $isPresentingEditBookInformationSheet) {
                ReadingBookEditView(readingBook: readingBook)
            }
            .confirmationDialog("도서를 삭제하시겠습니까?", isPresented: $isPresentingDeleteConfirmationDialog, titleVisibility: .visible) {
                Button("삭제", role: .destructive) {
                    realmManager.deleteReadingBook(readingBook)
                    dismiss()
                }
            }
    }
}

// MARK: - EXTENSIONS

extension ReadingBookHeaderView {
    var navigationBar: some View {
        HStack {
            Spacer()
            
            navigationBarTitle
            
            Spacer()
        }
        .overlay {
            navigationBarButtons
        }
        .padding(.vertical)
    }
    
    var navigationBarTitle: some View {
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
    
    var navigationBarButtons: some View {
        HStack {
            navigationBackButton
            
            Spacer()
            
            Menu {
                Section {
                    addBookSentenceButton
                    
                    Divider()
                    
                    editReadingBookButton

                    deleteReadingBoolButton
                } header: {
                    Text("도서 편집")
                }
            } label: {
                ellipsisSFSymbolsImage
            }
        }
    }
    
    var navigationBackButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .navigationBarItemStyle()
        }
    }
    
    var editReadingBookButton: some View {
        Button {
            isPresentingEditBookInformationSheet = true
        } label: {
            Label("편집", systemImage: "square.and.pencil")
        }
    }
    
    var deleteReadingBoolButton: some View {
        Button(role: .destructive) {
            isPresentingDeleteConfirmationDialog = true
        } label: {
            Label("삭제", systemImage: "trash")
        }
    }
    
    var addBookSentenceButton: some View {
        Button {
            // ...
        } label: {
            Label("문장 추가", systemImage: "bookmark.fill")
        }
    }
    
    var ellipsisSFSymbolsImage: some View {
        Image(systemName: "ellipsis")
            .navigationBarItemStyle()
    }
}

// MARK: - PREVIEW

struct TargetBookDetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookHeaderView(ReadingBook.preview, scrollYOffset: .constant(0.0))
            .environmentObject(RealmManager())
    }
}
