//
//  SentenceCellButton.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/06/01.
//

import SwiftUI

enum SentenceCellButtonType {
    case home
    case shelf
}

struct SentenceCellButton: View {
    
    let collect: CollectSentences
    let bookTitle: String
    
    init(_ collect: CollectSentences, bookTitle: String) {
        self.collect = collect
        self.bookTitle = bookTitle
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text(collect.sentence)
                    .fontWeight(.bold)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
                    .truncationMode(.middle)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding([.leading, .top, .trailing])
            
            HStack {
                Text(collect.date.standardDateFormat)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(collect.page)페이지")
                    .padding(.vertical, 3.2)
                    .padding(.horizontal, 15)
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding(.trailing, 15)
                
                Menu {
                    Button {
                        
                    } label: {
                        Label("수정", systemImage: "square.and.pencil")
                    }
                    
                    Button(role: .destructive) {
                        
                    } label: {
                        Label("삭제", systemImage: "trash")
                            .symbolVariant(.fill)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color.black)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color.background)
    }
}

struct SentenceCellButton_Previews: PreviewProvider {
    static var previews: some View {
        SentenceCellButton(CollectSentences.preview, bookTitle: "스티브 잡스")
    }
}
