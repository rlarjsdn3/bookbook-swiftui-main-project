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
    let showBackButton: Bool
    
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
                if let info = bookInfo, showBackButton {
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
            // 도서 세부 정보를 불러올 수 없으면 (showSearchError가 true이면) 밖으로 빠져나가고, toastUI 출력 (SearchSheet뷰에서)
            // 아마도 다양한 상황에 맞게 에러 메시지를 출력하는 코드를 추가 작성이 필요해 보임
            .onChange(of: aladinAPIManager.showSearchError) { newValue in
                if newValue {
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
        .toolbar(.hidden, for: .navigationBar)
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

struct SearchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfoView(isbn13: "9788994492049", showBackButton: true)
            .environmentObject(AladinAPIManager())
    }
}
