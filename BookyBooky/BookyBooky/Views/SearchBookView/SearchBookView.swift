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
    let viewType: SearchBookViewTypes
    
    // MARK: - COMPUTED PROPERTIES
    
    var categoryAccentColor: Color {
        if let bookDetail = aladinAPIManager.searchBookInfo {
            return bookDetail.category.accentColor
        }
        return Color.black
    }
    
    // MARK: - INTIALIZER
    
    init(_ isbn13: String, viewType: SearchBookViewTypes) {
        self.isbn13 = isbn13
        self.viewType = viewType
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                if let bookDetail = aladinAPIManager.searchBookInfo {
                    ZStack(alignment: .topLeading) {
                        detailBookInfo(bookDetail)
                        
                        if viewType == .navigationStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(bookDetail.category.foregroundColor)
                                    .padding()
                            }
                        }
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            hideKeyboard()
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
        .toast(isPresenting: $realmManager.isPresentingFavoriteBookAddCompleteToastAlert,
               duration: 1.0) {
            realmManager.showFavoriteBookAddCompleteToastAlert(categoryAccentColor)
        }
       .toast(isPresenting: $realmManager.isPresentingReadingBookAddCompleteToastAlert,
              duration: 1.0) {
           realmManager.showTargetBookAddCompleteToastAlert(categoryAccentColor)
       }
        .presentationCornerRadius(30)
    }
}

// MARK: - EXTENSIONS

extension SearchBookView {
    func detailBookInfo(_ book: detailBookInfo.Item) -> some View {
        VStack {
            SearchBookCoverView(
                book,
                isLoadingCoverImage: $isLoadingCoverImage
            )
            
            SearchBookTitleView(
                book,
                isLoadingCoverImage: $isLoadingCoverImage
            )
            
            SearchBookGrayBoxView(
                book,
                isLoadingCoverImage: $isLoadingCoverImage
            )
            
            Divider()
            
            SearchBookIntroView(
                book,
                isLoadingCoverImage: $isLoadingCoverImage
            )
            
            Spacer()
            
            SearchBookButtonsView(
                bookSearchInfo: book,
                isLoadingCoverImage: $isLoadingCoverImage
            )
        }
    }
}

// MARK: - PREVIEW

struct SearchInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView("9788994492049", viewType: .navigationStack)
            .environmentObject(RealmManager())
            .environmentObject(AladinAPIManager())
    }
}
