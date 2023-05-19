//
//  ReadingBookRenewalView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/05.
//

import SwiftUI
import RealmSwift

struct ReadingBookRenewalSheetView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var realmManager: RealmManager
    
    @Binding var isPresentingReadingBookConfettiView: Bool
    
    @State private var totalPagesRead = 0
    
    // MARK: - PROPERTIES
    
    let readingBook: ReadingBook
    
    // MARK: - INTIALIZER
    
    init(_ readingBook: ReadingBook, isPresentingReadingBookConfettiView: Binding<Bool>) {
        self.readingBook = readingBook
        self._isPresentingReadingBookConfettiView = isPresentingReadingBookConfettiView
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            howManyPagesDidYouReadText
            
            Spacer()
        
            VStack {
                Text("\(totalPagesRead)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .padding(.vertical, 2)
                
                Text("페이지")
                    .font(.title3.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .overlay {
                Group {
                    let readingBookPage = readingBook.itemPage
                    let lastRecordTotalPagesRead = readingBook.lastRecord?.totalPagesRead ?? 0
                    
                    HStack {
                        Button {
                            totalPagesRead -= 1
                        } label: {
                            Image(systemName: "minus")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(.vertical, 23)
                                .padding(.horizontal)
                                .background(readingBook.category.accentColor)
                                .clipShape(Circle())
                        }
                        .opacity(lastRecordTotalPagesRead >= totalPagesRead  ? 0.5 : 1)
                        .disabled(lastRecordTotalPagesRead >= totalPagesRead  ? true : false)
                        
                        Spacer()
                        
                        Button {
                            totalPagesRead  += 1
                        } label: {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(readingBook.category.accentColor)
                                .clipShape(Circle())
                        }
                        .opacity(readingBookPage <= totalPagesRead  ? 0.5 : 1)
                        .disabled(readingBookPage <= totalPagesRead  ? true : false)
                    }
                    .offset(y: -17)
                    .padding()
                }
            }
            .padding()
            
            Spacer()
            
            Button {
                realmManager.addReadingBookRecord(readingBook, totalPagesRead: totalPagesRead)
                
                
//                if lastRecord.totalPagesRead == readingBook.itemPage {
//                    if let object = realm.objects(ReadingBook.self).filter { $0.isbn13 == readingBook.isbn13 }.first {
//
//                        try! realm.write {
//                            object.completeDate = Date.now
//                        }
//                    }
//                }
                
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
            if let record = readingBook.lastRecord {
                totalPagesRead = record.totalPagesRead
            } else {
                totalPagesRead = 0
            }
        }
        .onDisappear {
            if readingBook.isComplete {
                isPresentingReadingBookConfettiView = true
            }
        }
        .presentationCornerRadius(30)
        .presentationDetents([.height(400)])
    }
}

extension ReadingBookRenewalSheetView {
    var howManyPagesDidYouReadText: some View {
        Text("어디까지 읽으셨나요?")
            .font(.title.weight(.bold))
            .offset(y: 45)
    }
}

// MARK: - PREVIEW

struct ReadingBookRenewalSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingBookRenewalSheetView(
            ReadingBook.preview,
            isPresentingReadingBookConfettiView: .constant(false)
        )
        .environmentObject(RealmManager())
    }
}
