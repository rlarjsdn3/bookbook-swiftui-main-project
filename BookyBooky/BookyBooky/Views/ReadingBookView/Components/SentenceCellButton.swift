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
    
    let bookTitle: String
    let accentColor: Color
    let collectSentence: CollectSentences
    
    init(_ bookTitle: String, accentColor: Color, collectSentence: CollectSentences) {
        self.bookTitle = bookTitle
        self.accentColor = accentColor
        self.collectSentence = collectSentence
    }
    
    var body: some View {
        VStack {
            NavigationLink {
                Text("dw")
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    Text(collectSentence.sentence)
                        .fontWeight(.bold)
                        .lineLimit(5)
                        .truncationMode(.middle)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding([.leading, .top, .trailing])
            }
            .buttonStyle(.plain)
            
            HStack {
                Text(collectSentence.date.standardDateFormat)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(collectSentence.page)페이지")
                    .padding(.vertical, 3.2)
                    .padding(.horizontal, 15)
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .background(accentColor)
                    .clipShape(Capsule())
                    .padding(.trailing)
                
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
                        .foregroundColor(accentColor)
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
        SentenceCellButton(
            "스티브 잡스",
            accentColor: Color.blue,
            collectSentence: CollectSentences.preview
        )
    }
}
