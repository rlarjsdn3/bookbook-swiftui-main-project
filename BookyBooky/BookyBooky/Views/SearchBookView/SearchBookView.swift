//
//  SearchDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import AlertToast

struct SearchBookView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    @EnvironmentObject var alertManager: AlertManager
    
    @StateObject var searchBookViewData = SearchBookViewData()
    
    // MARK: - PROPERTIES
    
    let isbn13: String
    let type: ViewType.SearchBookViewType
    
    // MARK: - COMPUTED PROPERTIES
    
    var categoryThemeColor: Color {
        if let bookDetail = aladinAPIManager.searchBookInfo {
            return bookDetail.bookCategory.themeColor
        }
        return Color.black
    }
    
    // MARK: - INTIALIZER
    
    init(_ isbn13: String, type: ViewType.SearchBookViewType) {
        self.isbn13 = isbn13
        self.type = type
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            Group {
                if let bookItem = aladinAPIManager.searchBookInfo {
                    VStack {
                        SearchBookCoverView(bookItem)
                            .overlay(alignment: .topLeading) {
                                if type == .navigation {
                                    Button {
                                        dismiss()
                                    } label: {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(bookItem.bookCategory.foregroundColor)
                                            .navigationBarItemStyle()
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                        
                        SearchBookMainInfoView(bookItem)
                        
                        SearchBookSubInfoView(bookItem)
                        
                        Divider()
                        
                        SearchBookDescView(bookItem)
                        
                        Spacer()
                        
                        SearchBookButtonGroupView(bookItem)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .environmentObject(searchBookViewData)
        }
        .onAppear {
            aladinAPIManager.requestBookDetailAPI(isbn13)
        }
        .onDisappear {
            aladinAPIManager.searchBookInfo = nil
        }
        .onChange(of: alertManager.isPresentingDetailBookErrorToastAlert) { error in
            if error {
                dismiss()
            }
        }
        .toast(isPresenting: $alertManager.isPresentingFavoriteBookAddSuccessToastAlert,
               duration: 1.0) {
            alertManager.showFavoriteBookAddSuccessToastAlert(categoryThemeColor)
        }
        .toast(isPresenting: $alertManager.isPresentingReadingBookAddSuccessToastAlert,
              duration: 1.0) {
           alertManager.showReadingBookAddSuccessToastAlert(categoryThemeColor)
        }
        .presentationCornerRadius(30)
    }
}

// MARK: - PREVIEW

struct SearchInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView("9788994492049", type: .navigation)
            .environmentObject(RealmManager())
            .environmentObject(AladinAPIManager())
            .environmentObject(AlertManager())
    }
}
