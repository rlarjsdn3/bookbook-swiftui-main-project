//
//  MailComposeView.swift
//  BookyBooky
//
//  Created by 김건우 on 7/6/23.
//

import SwiftUI
import MessageUI

struct MailComposeView: UIViewControllerRepresentable {
    
    let toRecipients: [String]
    let mailBody: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailComposeView>) -> MFMailComposeViewController {
        let mailView = MFMailComposeViewController()
        mailView.mailComposeDelegate = context.coordinator
        mailView.setToRecipients(self.toRecipients)
        mailView.setMessageBody(self.mailBody, isHTML: false)
        return mailView
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailComposeView>) { }
    
    func makeCoordinator() -> CoordinatorMailComposeView {
        return CoordinatorMailComposeView()
    }
}

final class CoordinatorMailComposeView: NSObject, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
