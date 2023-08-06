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
    
    var themeColor: Color {
        if let bookDetail = searchBookViewData.detailBookInfo {
            return bookDetail.bookCategory.themeColor
        }
        return Color.black
    }
    
    // MARK: - INTIALIZER
    
    init(_ isbn13: String, in type: ViewType.SearchBookViewType) {
        self.isbn13 = isbn13
        self.type = type
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            Group {
                if let bookItem = searchBookViewData.detailBookInfo {
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
                        
                        SearchBookDescriptionView(bookItem)
                        
                        Spacer()
                        
                        SearchBookButtonGroupView(bookItem)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .environmentObject(searchBookViewData)
        }
        .onAppear {
            aladinAPIManager.requestBookDetailInfo(isbn13) { book in
                DispatchQueue.main.async {
                    if let book = book {
                        searchBookViewData.detailBookInfo = book.item[0]
                    } else {
                        alertManager.isPresentingDetailBookErrorToastAlert = true
                    }
                }
            }
        }
        .onDisappear {
            searchBookViewData.detailBookInfo = nil
        }
        .onChange(of: alertManager.isPresentingDetailBookErrorToastAlert) { error in
            if error {
                dismiss()
            }
        }
        .toast(isPresenting: $alertManager.isPresentingFavoriteBookAddSuccessToastAlert,
               duration: 1.0) {
            alertManager.showFavoriteBookAddSuccessToastAlert(themeColor)
        }
        .toast(isPresenting: $alertManager.isPresentingReadingBookAddSuccessToastAlert,
              duration: 1.0) {
           alertManager.showReadingBookAddSuccessToastAlert(themeColor)
        }
        .presentationCornerRadius(30)
    }
}

// MARK: - PREVIEW

struct SearchBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView("9788994492049", in: .navigation)
            .environmentObject(RealmManager())
            .environmentObject(AladinAPIManager())
            .environmentObject(AlertManager())
    }
}
