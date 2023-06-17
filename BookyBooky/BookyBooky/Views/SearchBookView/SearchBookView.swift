//
//  SearchDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import AlertToast

enum SearchBookViewTypes {
    case sheet
    case navigationStack
}

struct SearchBookView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isLoadingCoverImage = true
    
    // MARK: - PROPERTIES
    
    let isbn13: String
    let type: SearchBookViewTypes
    
    // MARK: - COMPUTED PROPERTIES
    
    var categoryAccentColor: Color {
        if let bookDetail = aladinAPIManager.searchBookInfo {
            return bookDetail.bookCategory.themeColor
        }
        return Color.black
    }
    
    // MARK: - INTIALIZER
    
    init(_ isbn13: String, type: SearchBookViewTypes) {
        self.isbn13 = isbn13
        self.type = type
    }
    
    // MARK: - BODY
    
    var body: some View {
        searchBook
            .onAppear {
                aladinAPIManager.requestBookDetailAPI(isbn13)
            }
            .onDisappear {
                aladinAPIManager.searchBookInfo = nil
            }
            // 도서 정보 불러오기에 실패한다면 이전 화면으로 넘어갑니다.
            .onChange(of: aladinAPIManager.isPresentingDetailBookErrorToastAlert) { detailBookError in
                if detailBookError {
                    dismiss()
                }
            }
            .toast(isPresenting: $realmManager.isPresentingFavoriteBookAddSuccessToastAlert,
                   duration: 1.0) {
                realmManager.showFavoriteBookAddSuccessToastAlert(categoryAccentColor)
            }
            .toast(isPresenting: $realmManager.isPresentingReadingBookAddSuccessToastAlert,
                  duration: 1.0) {
               realmManager.showReadingBookAddSuccessToastAlert(categoryAccentColor)
            }
            .toolbar(.hidden, for: .navigationBar)
            .presentationCornerRadius(30)
    }
}

// MARK: - EXTENSIONS

extension SearchBookView {
    var searchBook: some View {
        NavigationStack {
            if let bookInfo = aladinAPIManager.searchBookInfo {
                VStack {
                    SearchBookCoverView(
                        bookInfo,
                        isLoadingCoverImage: $isLoadingCoverImage
                    )
                    .overlay(alignment: .topLeading) {
                        if type == .navigationStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(bookInfo.bookCategory.foregroundColor)
                                    .navigationBarItemStyle()
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    
                    SearchBookMainInfoView(
                        bookInfo,
                        isLoadingCoverImage: $isLoadingCoverImage
                    )
                    
                    SearchBookSubInfoView(
                        bookInfo,
                        isLoadingCoverImage: $isLoadingCoverImage
                    )
                    
                    Divider()
                    
                    SearchBookDescView(
                        bookInfo,
                        isLoadingCoverImage: $isLoadingCoverImage
                    )
                    
                    Spacer()
                    
                    SearchBookButtonGroupView(
                        bookInfo,
                        isLoadingCoverImage: $isLoadingCoverImage
                    )
                }
            }
        }
    }
}

// MARK: - PREVIEW

struct SearchInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView("9788994492049", type: .navigationStack)
            .environmentObject(RealmManager())
            .environmentObject(AladinAPIManager())
    }
}
