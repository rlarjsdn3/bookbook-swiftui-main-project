//
//  TargetBookDetailHeaderView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import SwiftUI
import RealmSwift

struct TargetBookDetailHeaderView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedResults(CompleteTargetBook.self) var completeTargetBooks
    
    let targetBook: CompleteTargetBook
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(targetBook.title)
                .frame(width: mainScreen.width * 0.65)
                .lineLimit(1)
                .truncationMode(.middle)
                .navigationTitleStyle()
            
            Spacer()
        }
        .overlay {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .navigationBarItemStyle()
                }
                
                Spacer()
                
                Menu {
                    Section {
                        Button {
                            // do something...
                        } label: {
                            Label("편집", systemImage: "square.and.pencil")
                        }

                        Button(role: .destructive) {
                            // 리팩토링 필요
                            do {
                                if let object = completeTargetBooks.filter("isbn13 == %@", targetBook.isbn13).first {
                                    
                                    $completeTargetBooks.remove(object)
                                }
                            } catch let error as NSError {
                                print("error - \(error.localizedDescription)")
                            }
                            dismiss()
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    } header: {
                        Text("도서 편집")
                    }

                } label: {
                    Image(systemName: "ellipsis")
                        .navigationBarItemStyle()
                }
            }
        }
        .padding(.vertical)
    }
}

struct TargetBookDetailHeaderView_Previews: PreviewProvider {
    @ObservedResults(CompleteTargetBook.self) static var completeTargetBooks
    
    static var previews: some View {
        TargetBookDetailHeaderView(targetBook: completeTargetBooks[0])
    }
}
