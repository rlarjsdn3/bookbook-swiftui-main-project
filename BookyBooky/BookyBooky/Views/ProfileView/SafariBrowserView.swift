//
//  SafariBrowserView.swift
//  BookyBooky
//
//  Created by 김건우 on 7/7/23.
//

import SwiftUI
import SafariServices

struct SafariBrowserView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let safariView = SFSafariViewController(url: url)
        safariView.modalPresentationStyle = .pageSheet
        return safariView
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
