//
//  ReadingBookRenewalView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/05.
//

import SwiftUI
import RealmSwift

struct ReadingBookRenewalView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var page: Int = 0
    
    var themeColor: Color {
        readingBook.category.accentColor
    }
    
    var body: some View {
        VStack {
            Text("어디까지 읽으셨나요?")
                .font(.title.weight(.bold))
                .offset(y: 50)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    // do something...
                } label: {
                    Image(systemName: "minus")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.vertical, 23)
                        .padding(.horizontal)
                        .background(themeColor)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                VStack {
                    Text("\(page)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .padding(.vertical, 2)
                    
                    Text("페이지")
                        .font(.title3.weight(.semibold))
                }
                .offset(y: 17)
                .padding()
                
                Spacer()
                
                Button {
                    // do something...
                } label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(themeColor)
                        .clipShape(Circle())
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
            
            Button {
                // 아직 미완성
                dismiss()
            } label: {
                Text("갱신하기")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(15)
            }
            .padding(.horizontal)
            
        }
        .onAppear {
            if let record = readingBook.readingRecords.last {
                page = record.totalPagesRead
            } else {
                page = 0
            }
        }
        .presentationCornerRadius(30)
        .presentationDetents([.height(400)])
    }
}

struct ReadingBookRenewalView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        ReadingBookRenewalView(readingBook: readingBooks[0])
    }
}
