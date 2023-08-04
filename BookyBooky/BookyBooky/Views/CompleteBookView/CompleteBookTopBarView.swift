//
//  TargetBookDetailHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import SwiftUI
import RealmSwift

struct CompleteBookTopBarView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var completeBookViewData: CompleteBookViewData
    
    @State private var isPresentingAddSentenceSheet = false
    @State private var isPresentingEditBookInformationSheet = false
    @State private var isPresentingDeleteConfirmationDialog = false
    
    // MARK: - PROPERTIES
    
    let completeBook: CompleteBook
    
    // MARK: - INTIALIZER
    
    init(_ completeBook: CompleteBook) {
        self.completeBook = completeBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        navigationTopBar
            .sheet(isPresented: $isPresentingEditBookInformationSheet) {
                CompleteBookEditView(completeBook)
                    .presentationCornerRadius(30)
            }
            .sheet(isPresented: $isPresentingAddSentenceSheet) {
                AddSentenceSheetView(completeBook)
                    .presentationCornerRadius(30)
            }
            .confirmationDialog("도서를 삭제하시겠습니까?", isPresented: $isPresentingDeleteConfirmationDialog, titleVisibility: .visible) {
                Button("삭제", role: .destructive) {
                    realmManager.deleteReadingBook(completeBook)
                    dismiss()
                }
            }
    }
}

// MARK: - EXTENSIONS

extension CompleteBookTopBarView {
    var navigationTopBar: some View {
        HStack {
            Spacer()
            
            navigationTopBarTitle
            
            Spacer()
        }
        .overlay {
            topBarButtonGroup
        }
        .padding(.vertical)
        .overlay(alignment: .bottom) {
            Divider()
                .opacity(
                    (completeBookViewData.scrollYOffset > 5.0 &&
                     completeBookViewData.scrollYOffset < 191.0) ? 1 : 0
                )
        }
    }
    
    var navigationTopBarTitle: some View {
        Group {
            if completeBookViewData.scrollYOffset > 30 {
                Text(completeBook.title)
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
    
    var topBarButtonGroup: some View {
        HStack {
            backButton
            
            Spacer()
            
            Menu {
                Section {
                    addSentenceButton
                    
                    Divider()
                    
                    editButton

                    deleteButton
                } header: {
                    Text("도서 편집")
                }
            } label: {
                ellipsisSFSymbolsImage
            }
        }
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .navigationBarItemStyle()
        }
    }
    
    var editButton: some View {
        Button {
            isPresentingEditBookInformationSheet = true
        } label: {
            Label("편집", systemImage: "square.and.pencil")
        }
    }
    
    var deleteButton: some View {
        Button(role: .destructive) {
            isPresentingDeleteConfirmationDialog = true
        } label: {
            Label("삭제", systemImage: "trash")
        }
    }
    
    var addSentenceButton: some View {
        Button {
            isPresentingAddSentenceSheet = true
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

#Preview {
    CompleteBookTopBarView(
        CompleteBook.preview
    )
    .environmentObject(CompleteBookViewData())
    .environmentObject(RealmManager())
}
