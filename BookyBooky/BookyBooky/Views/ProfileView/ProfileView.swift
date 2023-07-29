//
//  SettingsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import MessageUI
import StoreKit
import DeviceKit

struct ProfileView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentMailComposeView: Bool = false
    @State private var isPresentSafariBrowserSheetView: Bool = false
    @State private var isPresentAlertSendMailErrorAlert: Bool = false
    
    // MARK: - PROPERTIES
    
    let receiverAddress = ["rlarjsdn3@naver.com"]
    let mailBody: String
    
    init() {
        let appDeviceInfo = AppDeviceInfoProvider.current
        
        mailBody = """
        ✅ 버그 수정, 기능 개선 요청, 기타 등등 개발자에게 문의를 남겨주세요.

        -----------------------------
        ▪︎ 앱 버전(빌드): \(appDeviceInfo.appVersion) (\(appDeviceInfo.appBuild))
        ▪︎ 디바이스 기종: \(appDeviceInfo.deviceName) (\(appDeviceInfo.deviceDiagonal))
        ▪︎ 디바이스 버전: \(appDeviceInfo.deviceOS)
        -----------------------------
        """
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            List {
                inquirySection
                
                reviewSection
                
                #if false
                assistSection
                #endif
                
                Section {
                    HStack {
                        Text("버전")
                        
                        Spacer()
                        
                        Text(AppDeviceInfoProvider.current.appVersion)
                            .foregroundStyle(Color.secondary)
                    }
                    
                    HStack {
                        Text("빌드")
                        
                        Spacer()
                        
                        Text(AppDeviceInfoProvider.current.appBuild)
                            .foregroundStyle(Color.secondary)
                    }
                } header: {
                    Text("앱 정보")
                }

            }
            .navigationTitle("설정")
        }
        .sheet(isPresented: $isPresentMailComposeView) {
            MailComposeView(
                toRecipients: receiverAddress,
                mailBody: mailBody
            )
            // 이 구문을 써주지 않으면 시트 하단이 뻥 비어보이게 됨!
            .ignoresSafeArea(.container, edges: .bottom)
            .presentationCornerRadius(30)
        }
        .alert("메일을 보낼 수 없습니다.", isPresented: $isPresentAlertSendMailErrorAlert) {
            // ...
        } message: {
            Text("기기에 메일 계정을 추가해주세요.")
        }
        .presentationCornerRadius(30)
    }
    
    // MARK: - FUNCTIONS
    
    func rowLabel(_ systemImageName: String, title: String, color: Color) -> some View {
        HStack {
            Image(systemName: systemImageName)
                .foregroundStyle(Color.white)
                .frame(width: 28, height: 28)
                .background(color, in: .rect(cornerRadius: 8))
                .padding(.trailing, 8)
            Text(title)
                .foregroundStyle(Color.black)
        }
    }
    
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                  SKStoreReviewController.requestReview(in: scene)
        }
    }
}

// MARK: - EXTENSIONS

extension ProfileView {
    var inquirySection: some View {
        Section {
            inquiryButton
        } header: {
            Text("문의")
        } footer: {
            Text("앱 이용 중 궁금한 점이 생기면 언제든지 개발자에게 문의해주세요 :)")
        }
    }
    
    var inquiryButton: some View {
        Button {
            if MFMailComposeViewController.canSendMail() {
                isPresentMailComposeView = true
            } else {
                isPresentAlertSendMailErrorAlert = true
            }
        } label: {
            rowLabel("envelope.fill", title: "개발자에게 문의하기", color: Color.blue)
        }
    }
    
    var reviewSection: some View {
        Section {
            Button {
                requestReview()
            } label: {
                rowLabel("pencil", title: "리뷰 남기기", color: Color.mint)
            }
        } header: {
            Text("평가")
        }
    }
    
    var assistSection: some View {
        Section {
           assistDeveloperButton
        } header: {
            Text("후원")
        } footer: {
            Text("여러분의 후원이 개발자를 행복하게 합니다♥︎")
        }
    }
    
    var assistDeveloperButton: some View {
        NavigationLink {
            Text("heart.fill")
        } label: {
            rowLabel("heart.fill", title: "개발자에게 커피 사주기", color: Color.pink)
        }
    }
}

// MARK: - PREVIEW

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
