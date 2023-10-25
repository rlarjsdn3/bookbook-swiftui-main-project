//
//  SettingsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import MessageUI
import StoreKit
import Kingfisher

struct ProfileView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @State private var isPresentMailComposeView: Bool = false
    @State private var isPresentAlertSendMailErrorAlert: Bool = false
    
    @State private var diskCacheSize: String = "0.0"
    
    // MARK: - PROPERTIES
    
    let receiverAddress = ["rlarjsdn3@naver.com"]
    let mailBody: String = """
    ✅ 버그 수정, 기능 개선 요청, 기타 등등 개발자에게 문의를 남겨주세요.

    -----------------------------
    ▪︎ 앱 버전(빌드): \(AppDeviceInfoProvider.appVersion) (\(AppDeviceInfoProvider.appBuild))
    ▪︎ 디바이스 기종: \(AppDeviceInfoProvider.deviceName) (\(AppDeviceInfoProvider.deviceDiagonal)인치)
    ▪︎ 디바이스 버전: \(AppDeviceInfoProvider.deviceOS)
    -----------------------------
    """
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            List {
                inquirySection
                
                cacheSection
                
                reviewSection
                
                
                Section {
                    HStack {
                        Text("버전")
                        
                        Spacer()
                        
                        Text(AppDeviceInfoProvider.appVersion)
                            .foregroundStyle(Color.secondary)
                    }
                    
                    HStack {
                        Text("빌드")
                        
                        Spacer()
                        
                        Text(AppDeviceInfoProvider.appBuild)
                            .foregroundStyle(Color.secondary)
                    }
                    
                    NavigationLink("저작권") {
                        CopyRightView()
                    }
                } header: {
                    Text("앱 정보")
                }

            }
            .navigationTitle("설정")
        }
        .onAppear {
            let imageCache = ImageCache.default
            imageCache.calculateDiskStorageSize { result in
                switch result {
                case .success(let size):
                    let size = Float(size) / 1024.0 / 1024.0
                    let formatter = NumberFormatter()
                    formatter.minimumFractionDigits = 1
                    diskCacheSize = formatter.string(from: size as NSNumber) ?? "0.0"
                case .failure:
                    print("캐시 사이즈 계산 실패")
                }
            }
        }
        .sheet(isPresented: $isPresentMailComposeView) {
            MailComposeView(
                toRecipients: receiverAddress,
                mailBody: mailBody
            )
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
                .background(color, in: RoundedRectangle(cornerRadius: 8))
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
                rowLabel("pencil", title: "평가 및 리뷰 남기기", color: Color.mint)
            }
        } header: {
            Text("평가")
        }
    }
    
    var cacheSection: some View {
        Section {
            HStack {
                rowLabel("externaldrive.fill", title: "캐시", color: Color.gray)
                Spacer()
                Text("\(diskCacheSize)MB")
                    .foregroundStyle(Color.secondary)
            }
            Button("캐시 비우기") {
                let imageCache = ImageCache.default
                imageCache.clearDiskCache {
                    self.diskCacheSize = "0"
                }
            }
        } header: {
            Text("캐시")
        } footer: {
            Text("자주 보는 도서 표지 이미지를 빠르게 불러오기 위해 데이터를 캐시에 저장합니다. 이 작업은 자동으로 수행되며, 임의로 켜거나 끌 수 없습니다.")
        }
    }
}

// MARK: - PREVIEW

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
