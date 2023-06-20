//
//  SettingsView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        Text("heart.fill") // 임시
                    } label: {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Color.white)
                                .frame(width: 27, height: 27)
                                .background(Color.pink, in: .rect(cornerRadius: 7))
                            Text("개발자에게 커피사주기")
                        }
                    }
                } header: {
                    Text("문의")
                } footer: {
                    Text("(문의 설명)")
                }
                
                Section {
                    NavigationLink {
                        Text("heart.fill") // 임시
                    } label: {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Color.white)
                                .frame(width: 27, height: 27)
                                .background(Color.pink, in: .rect(cornerRadius: 7))
                            Text("개발자에게 커피사주기")
                        }
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
