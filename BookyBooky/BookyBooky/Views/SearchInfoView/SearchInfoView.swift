//
//  SearchDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/03.
//

import SwiftUI
import AlertToast

struct SearchInfoView: View {
    
    // MARK: - COMPUTED PROPERTIES
    
    var bookInfo: BookInfo.Item? {
        guard !aladinAPIManager.BookInfoItem.isEmpty else {
            return nil
        }
        return aladinAPIManager.BookInfoItem[0]
    }
    
    var categoryThemeColor: Color {
        if let book = bookInfo {
            return book.categoryName.refinedCategory.accentColor
        } else {
            return Color.gray
        }
    }
    
    // MARK: - PROPERTIES
    
    let isbn13: String
    let isPresentingBackButton: Bool
    
    // MARK: - WRAPPER PROPERTIES]
    
    @EnvironmentObject var realmManager: RealmManager
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isLoading = true
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                // 도서 상세 데이터가 정상적으로 로드된 경우
                if let info = bookInfo {
                    bookInformation(item: info) // 상세 뷰 출력하기
                }
            }
            .overlay(alignment: .topLeading) {
                if let info = bookInfo, isPresentingBackButton {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(info.categoryName.refinedCategory.foregroundColor)
                            .padding()
                    }
                }
            }
            .onChange(of: aladinAPIManager.isPresentingInfoErrorUI) { isPresentingInfoErrorUI in
                if isPresentingInfoErrorUI {
                    dismiss()
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toast(isPresenting: $realmManager.isPresentingFavoriteBookAddCompleteToastAlert, duration: 1.0) {
                realmManager.showFavoriteBookAddCompleteToastAlert(categoryThemeColor)
        }
        .toast(isPresenting: $realmManager.isPresentingTargetBookAddCompleteToastAlert, duration: 1.0) {
            realmManager.showTargetBookAddCompleteToastAlert(categoryThemeColor)
        }
        .onAppear {
            aladinAPIManager.requestBookDetailAPI(isbn13: isbn13)
            hideKeyboard()
        }
        .onDisappear {
            aladinAPIManager.BookInfoItem.removeAll()
        }
        .presentationCornerRadius(30)
    }
}

// MARK: - EXTENSIONS

extension SearchInfoView {
    func bookInformation(item: BookInfo.Item) -> some View {
        VStack {
            SearchInfoCoverView(
                bookInfo: item,
                isLoading: $isLoading
            )
            
            SearchInfoTitleView(
                bookInfo: item,
                isLoading: $isLoading
            )
            
            SearchInfoBoxView(
                bookInfo: item,
                isLoading: $isLoading
            )
            
            Divider()
            
            SearchInfoDescView(
                bookInfo: item,
                isLoading: $isLoading
            )
            
            Spacer()
            
            SearchInfoButtonsView(
                bookInfo: item,
                isLoading: $isLoading
            )
        }
    }
}

// MARK: - PREVIEW

struct SearchInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoView(isbn13: "9788994492049", isPresentingBackButton: true)
            .environmentObject(RealmManager())
            .environmentObject(AladinAPIManager())
    }
}
