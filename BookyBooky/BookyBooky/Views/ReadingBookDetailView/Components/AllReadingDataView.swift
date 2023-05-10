//
//  AllReadingDataView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/05.
//

import SwiftUI
import RealmSwift

struct AllReadingDataView: View {
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var isPresentingDeleteLastDataConfirmationDialog = false
    @State private var isPresentingDeleteallDataConfirmationDialog = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if !readingBook.readingRecords.isEmpty {
                        ForEach(readingBook.readingRecords, id: \.self) { record in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(record.numOfPagesRead)페이지")
                                    
                                    Text("\(record.totalPagesRead)페이지까지 읽음")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                    
                                }
                                
                                Spacer()
                                
                                // 사용자 format으로 Date 확장하기
                                Text("\(record.date.formatted(.dateTime.locale(Locale(identifier: "ko")).year().month().day().weekday(.short)))")
                            }
                            .padding(.vertical, 1)
                        }
                    } else {
                        Text("데이터 없음")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("페이지")
                }
                
                Group {
                    Section {
                        Button("마지막 데이터 삭제하기") {
                            isPresentingDeleteLastDataConfirmationDialog = true
                        }
                    } footer: {
                        Text("독서 데이터의 일관성과 정확성을 유지하기 위해 개별 독서 데이터의 수정은 불가능합니다. 더불어, 마지막 독서 데이터의 삭제만 가능합니다. 이 작업은 취소할 수 없습니다.")
                    }
                    
                    Section {
                        Button("모든 데이터 삭제하기", role: .destructive) {
                            isPresentingDeleteallDataConfirmationDialog = true
                        }
                    } footer: {
                        Text("모든 독서 데이터를 삭제합니다. 이 작업은 취소할 수 없습니다.")
                    }
                }
                .disabled(readingBook.readingRecords.isEmpty)

            }
            .confirmationDialog("마지막으로 추가된 독서 데이터를 삭제하시겠습니까?", isPresented: $isPresentingDeleteLastDataConfirmationDialog, titleVisibility: .visible) {
                Button("삭제", role: .destructive) {
                    $readingBook.readingRecords.remove(at: readingBook.readingRecords.endIndex - 1)
                }
            } message: {
                Text("이 작업은 취소할 수 없습니다.")
            }
            .confirmationDialog("모든 독서 데이터를 삭제하시겠습니까?", isPresented: $isPresentingDeleteallDataConfirmationDialog, titleVisibility: .visible) {
                Button("삭제", role: .destructive) {
                    for _ in readingBook.readingRecords.indices {
                        $readingBook.readingRecords.remove(at: 0)
                    }
                }
            } message: {
                Text("이 작업은 취소할 수 없습니다.")
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
        AllReadingDataView(readingBook: readingBooks[0])
    }
}
