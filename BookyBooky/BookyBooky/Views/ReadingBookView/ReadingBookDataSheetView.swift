//
//  AllReadingDataView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/05.
//

import SwiftUI
import RealmSwift

struct ReadingBookDataSheetView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var isPresentingDeleteLastDataConfirmationDialog = false
    @State private var isPresentingDeleteallDataConfirmationDialog = false
    
    // MARK: - PROPERTIES
    
    let readingBook: ReadingBook
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook) {
        self.readingBook = readingBook
    }
    
    // MARK: - BODY
    
    var body: some View {
        recordCotent
            .confirmationDialog("마지막으로 추가된 독서 데이터를 삭제하시겠습니까?", isPresented: $isPresentingDeleteLastDataConfirmationDialog, titleVisibility: .visible) {
                Button("삭제", role: .destructive) {
                    realmManager.deleteLastRecord(readingBook)
                }
            } message: {
                Text("이 작업은 취소할 수 없습니다.")
            }
            .confirmationDialog("모든 독서 데이터를 삭제하시겠습니까?", isPresented: $isPresentingDeleteallDataConfirmationDialog, titleVisibility: .visible) {
                Button("삭제", role: .destructive) {
                    realmManager.deleteAllRecord(readingBook)
                }
            } message: {
                Text("이 작업은 취소할 수 없습니다.")
            }
            .presentationCornerRadius(30)
    }
}

extension ReadingBookDataSheetView {
    var recordCotent: some View {
        NavigationStack {
            recordScroll
                .navigationTitle("기록된 모든 데이터")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var recordScroll: some View {
        List {
            recordsSection
            
            deleteButtonGroup
        }
    }
    
    var recordsSection: some View {
        Section {
            if readingBook.readingRecords.isEmpty {
                noDataLabel
            } else {
                recordCellGroup
            }
        } header: {
            Text("페이지")
        } footer: {
            Text("동일한 일자에 여러 번 독서 데이터를 추가하는 경우, 가장 마지막으로 추가된 시간을 기준으로 독서 데이터가 기록됩니다.")
        }
    }
    
    var noDataLabel: some View {
        Text("데이터 없음")
            .foregroundColor(.secondary)
    }
    
    var recordCellGroup: some View {
        ForEach(readingBook.readingRecords, id: \.self) { record in
            recordCell(record)
        }
    }
    
    func recordCell(_ record: ReadingRecord) -> some View {
        HStack {
            pageLabel(record)
            
            Spacer()
            
            dateLabel(record)
        }
        .padding(.vertical, 1)
    }
    
    func pageLabel(_ record: ReadingRecord) -> some View {
        VStack(alignment: .leading) {
            Text("\(record.numOfPagesRead)페이지")
            
            Text("\(record.totalPagesRead)페이지까지 읽음")
                .font(.footnote)
                .foregroundColor(.secondary)
            
        }
    }
    
    func dateLabel(_ record: ReadingRecord) -> some View {
        VStack(alignment: HorizontalAlignment.trailing) {
            Text("\(record.date.standardDateFormat)")
            
            Text("\(record.date.standardTimeFormat)")
                .font(.footnote)
                .foregroundColor(Color.secondary)
        }
    }
    
    var deleteButtonGroup: some View {
        Group {
            deleteLastRecordButton
            
            deleteAllRecordButton
        }
        .disabled(readingBook.readingRecords.isEmpty)
    }
    
    var deleteLastRecordButton: some View {
        Section {
            Button("마지막 데이터 삭제하기") {
                isPresentingDeleteLastDataConfirmationDialog = true
            }
        } footer: {
            Text("독서 데이터의 일관성과 정확성을 유지하기 위해 개별 독서 데이터의 수정은 불가능합니다. 더불어, 마지막 독서 데이터의 삭제만 가능합니다. 이 작업은 취소할 수 없습니다.")
        }
    }
    
    var deleteAllRecordButton: some View {
        Section {
            Button("모든 데이터 삭제하기", role: .destructive) {
                isPresentingDeleteallDataConfirmationDialog = true
            }
        } footer: {
            Text("모든 독서 데이터를 삭제합니다. 이 작업은 취소할 수 없습니다.")
        }
    }
}

struct ReadingDataSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookDataSheetView(ReadingBook.preview)
            .environmentObject(RealmManager())
    }
}
