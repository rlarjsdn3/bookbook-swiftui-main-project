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
    
    // MARK: - PROPERTIES
    
    let isbn13: String
    let isPresentingBackButton: Bool
    
    // MARK: - WRAPPER PROPERTIES]
    
    @EnvironmentObject var aladinAPIManager: AladinAPIManager
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isLoading = true
    @State private var isPresentingFavoriteAlert = false
    
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
        .toast(isPresenting: $isPresentingFavoriteAlert, duration: 1.0) {
            AlertToast(
                displayMode: .alert,
                type: .complete(!aladinAPIManager.BookInfoItem.isEmpty ? aladinAPIManager.BookInfoItem[0].categoryName.refinedCategory.accentColor : .gray),
                title: "찜하기"
            )
        }
        .onAppear {
            aladinAPIManager.requestBookDetailAPI(isbn13: isbn13)
            hideKeyboard()
        }
        .onDisappear {
            aladinAPIManager.BookInfoItem.removeAll()
        }
        .toolbar(.hidden, for: .navigationBar)
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
                isLoading: $isLoading,
                isPresentingFavoriteAlert: $isPresentingFavoriteAlert
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
            .environmentObject(AladinAPIManager())
    }
}
