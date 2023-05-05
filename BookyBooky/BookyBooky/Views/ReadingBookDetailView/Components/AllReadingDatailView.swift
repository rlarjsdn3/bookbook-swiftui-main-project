//
//  AllReadingDataView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/05.
//

import SwiftUI
import RealmSwift

struct AllReadingDatailView: View {
    @ObservedRealmObject var readingBook: ReadingBook
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(readingBook.readingRecords, id: \.self) { record in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(record.totalPagesRead)쪽까지 읽음")
                                
                                Text("총 \(record.numOfPagesRead)쪽 읽음")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(record.date.formatted(date: .abbreviated, time: .omitted))")
                        }
                        .padding(.vertical, 1)
                    }
                    .onDelete { indexSet in
                        $readingBook.readingRecords.remove(atOffsets: indexSet)
                    }
                } header: {
                    Text("Pages")
                }

            }
            .toolbar {
                EditButton()
            }
            .navigationTitle("기록된 모든 데이터")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationCornerRadius(30)
    }
}

struct AllReadingDataView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var readingBooks
    
    static var previews: some View {
        AllReadingDatailView(readingBook: readingBooks[0])
    }
}
