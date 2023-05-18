//
//  ActivityScrollView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/18.
//

import SwiftUI
import RealmSwift

struct ActivityScrollView: View {
    
    // MARK: - WRAPPER PROPERTIES
    
    @EnvironmentObject var realmManager: RealmManager
    
    // MARK: - BODY
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ForEach(realmManager.getMonthlyReadingActivity(), id: \.self) { activity in
                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Label("독서일", systemImage: "calendar.circle.fill")
                                        .font(.headline.weight(.bold))
                                    
                                    Spacer()
                                    
                                    Text("\(realmManager.getMonthlyReadingDayCount(activity))일")
                                }
                                
                                HStack {
                                    Label("완독한 권수", systemImage: "book.closed.circle.fill")
                                        .font(.headline.weight(.bold))
                                    
                                    Spacer()
                                    
                                    Text("\(activity.activities.reduce(0, { $1.itemPage == $1.totalPagesRead ? $0 + 1 : $0 }))권")
                                        .foregroundColor(Color.purple)
                                }
                                
                                HStack(alignment: .firstTextBaseline) {
                                    Label("읽은 페이지", systemImage: "paperclip.circle.fill")
                                        .font(.headline.weight(.bold))
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text("\(activity.activities.reduce(0, { $0 + $1.numOfPagesRead }))페이지")
                                            .foregroundColor(Color.pink)
                                        
                                        // 실질적인 일자 개수를 세아려 평균 구하기 (수정 필요)
                                        Text("하루 평균 \( activity.activities.reduce(0, { $0 + $1.numOfPagesRead }) / realmManager.getMonthlyReadingDayCount(activity) )페이지")
                                            .font(.footnote)
                                            .foregroundColor(Color.secondary)
                                    }
                                }
                            }
                            .padding()
                            
                            Spacer()
                        }
                        
                        ForEach(activity.activities.sorted { $0.date < $1.date }, id: \.self) { data in
                            ActivityCellButton(data)
                        }
                    } header: {
                        Text(activity.date.toFormat("yyyy년 M월"))
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
}

// MARK: - EXTENSIONS

// MARK: - PREVIEW

struct ActivityScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityScrollView()
            .environmentObject(RealmManager())
    }
}
