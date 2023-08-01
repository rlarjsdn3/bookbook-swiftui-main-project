//
//  AlertManager.swift
//  BookyBooky
//
//  Created by 김건우 on 8/1/23.
//

import SwiftUI
import AlertToast

final class AlertManager: ObservableObject {
    
    // MARK: - WRAPPER PROPERTIES (Realm 관련)
    
    @Published var isPresentingReadingBookAddSuccessToastAlert = false
    @Published var isPresentingReadingBookEditSuccessToastAlert = false
    @Published var isPresentingReadingBookRenewalSuccessToastAlert = false
    @Published var isPresentingFavoriteBookAddSuccessToastAlert = false
    @Published var isPresentingAddSentenceSuccessToastAlert = false
    
    // MARK: - ALERT FUNCTIONS (Realm 관련)
    
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
}
