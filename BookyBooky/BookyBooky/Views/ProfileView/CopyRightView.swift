//
//  CopyRightView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/08/07.
//

import SwiftUI

struct CopyRightView: View {
    
    let appIconMakerUrl = URL(string: "https://www.flaticon.com/authors/freepik")!
    let flaticonSiteUrl =  URL(string: "wwww.flacticon.com")!
    
    let lottieMakerUrl = URL(string: "https://lottiefiles.com/m43tp3iaafsjf3zy")!
    let lottieFilesSiteUrl = URL(string: "https://lottiefiles.com/kr/")!
    
    var body: some View {
        List {
            appIconCopyrightRow
            
            lottieFilesCopyrightRow
        }
        .scrollIndicators(.hidden)
        .navigationTitle("저작권")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - EXTENSIONS

extension CopyRightView {
    var appIconCopyrightRow: some View {
        HStack {
            Text("앱 아이콘")
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                HStack(spacing: 5) {
                    Text("Icon made by")
                    Link("Freepik", destination: appIconMakerUrl)
                }
                HStack(spacing: 5) {
                    Text("from")
                    Link("www.flacticon.com", destination: flaticonSiteUrl)
                }
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
            }
        }
    }
    
    var lottieFilesCopyrightRow: some View {
        HStack {
            Text("로티 이미지")
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                VStack(alignment: .trailing, spacing: 0) {
                    Text("LottieFiles made by")
                    Link("Mahomed Askhabaliiev", destination: lottieMakerUrl)
                }
                HStack(spacing: 5) {
                    Text("from")
                    Link("www.lottiefiles.com", destination: lottieFilesSiteUrl)
                }
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
            }
        }
    }
}

// MARK: - PREVIEW

struct CopyRightView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CopyRightView()
        }
    }
}
