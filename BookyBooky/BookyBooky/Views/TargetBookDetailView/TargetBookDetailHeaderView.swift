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
    @Binding var scrollYOffset: Double
    
    @State var title: String = ""
    
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Text("도서 정보")
                    .navigationTitleStyle()
                    .opacity(scrollYOffset > 29 ? 0 : 1)
                
                Text(title)
                    .frame(width: mainScreen.width * 0.65)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .navigationTitleStyle()
                    .opacity(scrollYOffset > 30 ? 1 : 0)
            }
            
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
                            dismiss()
                            do {
                                if let object = completeTargetBooks.filter("isbn13 == %@", targetBook.isbn13).first {
                                    $completeTargetBooks.remove(object)
                                }
                            } catch let error as NSError {
                                print("error - \(error.localizedDescription)")
                            }
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
        .onAppear {
            title = targetBook.title
        }
        .padding(.vertical)
    }
}

struct TargetBookDetailHeaderView_Previews: PreviewProvider {
    @ObservedResults(CompleteTargetBook.self) static var completeTargetBooks
    
    static var previews: some View {
        TargetBookDetailHeaderView(targetBook: completeTargetBooks[0], scrollYOffset: .constant(0.0))
    }
}
