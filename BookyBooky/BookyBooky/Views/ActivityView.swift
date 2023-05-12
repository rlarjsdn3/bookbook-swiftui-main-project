//
//  ActivityView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/12.
//

import SwiftUI
import RealmSwift

struct ActivityView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedResults(ReadingBook.self) var readingBooks
    
    struct MonthlyActivity: Hashable {
        var month: Date
        var activity: [Activity]
    }
    
    var monthlyActivityData: [MonthlyActivity] {
        var monthlyActivity: [MonthlyActivity] = []
        
        readingBooks.forEach { readingBook in
            readingBook.readingRecords.forEach { record in
                if let index = monthlyActivity.firstIndex(where: {
                    $0.month.isEqual([.year, .month], date: record.date)
                }) {
                    monthlyActivity[index].activity.append(
                        Activity(date: record.date, title: readingBook.title, author: readingBook.author, category: readingBook.category, itemPage: readingBook.itemPage, isbn13: readingBook.isbn13, numOfPagesRead: record.numOfPagesRead, totalPagesRead: record.totalPagesRead)
                    )
                } else {
                    monthlyActivity.append(
                        MonthlyActivity(
                            month: record.date,
                            activity: [
                                Activity(date: record.date, title: readingBook.title, author: readingBook.author, category: readingBook.category, itemPage: readingBook.itemPage, isbn13: readingBook.isbn13, numOfPagesRead: record.numOfPagesRead, totalPagesRead: record.totalPagesRead)
                            ]
                        )
                    )
                }
            }
        }
        
        monthlyActivity.sort { $0.month > $1.month }
        
        return monthlyActivity
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Text("활동")
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
                }
            }
            .padding(.vertical)
            
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    ForEach(monthlyActivityData, id: \.self) { activity in
                        Section {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Label("독서일", systemImage: "calendar.circle.fill")
                                            .font(.headline.weight(.bold))
                                        
                                        Spacer()
                                        
                                        Text("\(activity.activity.count)일")
                                    }
                                    
                                    HStack {
                                        Label("완독한 권수", systemImage: "book.closed.circle.fill")
                                            .font(.headline.weight(.bold))
                                        
                                        Spacer()
                                        
                                        Text("\(activity.activity.reduce(0, { $1.itemPage == $1.totalPagesRead ? $0 + 1 : $0 }))권")
                                            .foregroundColor(Color.purple)
                                    }
                                    
                                    HStack(alignment: .firstTextBaseline) {
                                        Label("읽은 페이지", systemImage: "paperclip.circle.fill")
                                            .font(.headline.weight(.bold))
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            Text("\(activity.activity.reduce(0, { $0 + $1.numOfPagesRead }))페이지")
                                                .foregroundColor(Color.pink)
                                            
                                            Text("하루 평균 \( activity.activity.reduce(0, { $0 + $1.numOfPagesRead }) / activity.activity.count )페이지")
                                                .font(.footnote)
                                                .foregroundColor(Color.secondary)
                                        }
                                    }
                                }
                                .padding()
                                
                                Spacer()
                            }
                            
                            ForEach(activity.activity.sorted { $0.date < $1.date }, id: \.self) { data in
                                ActivityCellView(activity: data)
                            }
                        } header: {
                            Text(activity.month.formatted(.dateTime.year().month()))
                                .font(.headline.weight(.bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 10)
                                .padding(.bottom, 5)
                                .padding(.leading, 15)
                                .background(.white)
                        }
                        
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
