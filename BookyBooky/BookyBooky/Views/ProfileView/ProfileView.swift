//
//  SettingsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import MessageUI

struct ProfileView: View {
    
    @State private var isPresentMailComposeView: Bool = false
    @State private var isPresentAlertSendMailErrorAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        if MFMailComposeViewController.canSendMail() {
                            isPresentMailComposeView = true
                        } else {
                            isPresentAlertSendMailErrorAlert = true
                        }
                    } label: {
                        rowLabel("envelope.fill", title: "개발자에게 문의하기", color: Color.blue)
                    }
//                    .buttonStyle(.plain)
                    
                    Link(destination: URL(string: "https://www.apple.com")!) {
                        rowLabel("ladybug.fill", title: "건의 및 버그 리포트", color: Color.orange)
                    }
//                    .buttonStyle(.plain)
                } header: {
                    Text("문의")
                } footer: {
                    Text("앱 이용 중 궁금한 점이 생기면 언제든지 개발자에게 문의해주세요 :)")
                }
                
                Section {
                    NavigationLink {
                        Text("heart.fill") // 임시
                    } label: {
                        rowLabel("heart.fill", title: "개발자에게 커피 사주기", color: Color.pink)
                    }
                } header: {
                    Text("후원")
                } footer: {
                    Text("여러분의 후원이 개발자를 행복하게 합니다♥︎")
                }
            }
            .navigationTitle("설정")
        }
        .presentationCornerRadius(30)
        .sheet(isPresented: $isPresentMailComposeView) {
            MailComposeView(toRecipients: ["rlarjsdn3@naver.com"], mailBody: "안녕")
                .presentationCornerRadius(30)
        }
        .alert("메일을 보낼 수 없습니다.", isPresented: $isPresentAlertSendMailErrorAlert) {
            // ...
        } message: {
            Text("기기에 메일 계정을 추가해주세요.")
        }
    }
}

extension ProfileView {
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
