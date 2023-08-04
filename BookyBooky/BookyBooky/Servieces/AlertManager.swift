//
//  AlertManager.swift
//  BookyBooky
//
//  Created by 김건우 on 8/1/23.
//

import SwiftUI
import AlertToast

final class AlertManager: ObservableObject {
    
    // MARK: - WRAPPER PROPERTIES (네트워크 관련)
    
    @Published var isPresentingNetworkErrorToastAlert = false
    
    // MARK: - WRAPPER PROPERTIES (CRUD 관련)
    
    @Published var isPresentingReadingBookAddSuccessToastAlert = false
    @Published var isPresentingReadingBookEditSuccessToastAlert = false
    @Published var isPresentingReadingBookRenewalSuccessToastAlert = false
    @Published var isPresentingFavoriteBookAddSuccessToastAlert = false
    @Published var isPresentingAddSentenceSuccessToastAlert = false
    
    // MARK: - WRAPPER PROPERTIES (API 통신 관련)
    
    @Published var isPresentingBookListLoadingToastAlert = false
    @Published var isPresentingSearchLoadingToastAlert = false  // 도서 검색 로딩 UI의 출력을 제어하는 변수
    @Published var isPresentingSearchErrorToastAlert = false    // 도서 검색 에러 UI의 출력을 제어하는 변수
    @Published var isPresentingDetailBookErrorToastAlert = false      // 도서 상세 에러 UI의 출력을 제어하는 변수
    
    // MARK: - ALERT PROPERTIES (네트워크 관련)
    
    let showNetworkErrorToastAlert = AlertToast(displayMode: .hud, type: .error(Color.red), title: "인터넷 연결이 끊어짐", subTitle: "인터넷 연결을 확인해주세요.")
    
    // MARK: - ALERT FUNCTIONS (CRUD 관련)
    
    func showReadingBookAddSuccessToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "도서 추가 완료")
    }
    
    func showReadingBookEditSuccessToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "도서 편집 완료")
    }
    
    func showReadingBookRenewalSuccessToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "도서 갱신 완료")
    }
    
    func showFavoriteBookAddSuccessToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "찜하기 완료")
    }
    
    func showAddSentenceSuccessToastAlert(_ color: Color) -> AlertToast {
        AlertToast(displayMode: .alert, type: .complete(color), title: "문장 추가 완료")
    }
    
    // MARK: - ALERT PROPERTIES (API 통신 관련)
    
    let showBookListLoadingToastAlert = AlertToast(displayMode: .alert, type: .loading, title: "도서 정보 불러오는 중")
    let showSearchLoadingToastAlert = AlertToast(displayMode: .banner(.pop), type: .loading, title: "도서 정보 불러오는 중...")
    let showSearchErrorToastAlert = AlertToast(displayMode: .banner(.pop), type: .error(.red), title: "도서 정보 불러오기 실패", subTitle: "       잠시 후 다시 시도하십시오.")
    let showDetailBookErrorToastAlert = AlertToast(displayMode: .banner(.pop), type: .error(.red), title: "도서 정보 불러오기 실패", subTitle: "       해당 도서 정보를 찾을 수 없습니다.")
}
