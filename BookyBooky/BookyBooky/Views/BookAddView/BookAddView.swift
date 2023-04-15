//
//  BookAddView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/12.
//

import SwiftUI
import SwiftDate

struct BookAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let bookInfoItem: BookInfo.Item
    
    @State private var selectedDate: Date = Date() + 7.days
    
    @State private var isPresentingDateDescSheet = false
    @State private var isPresentingDatePickerSheet = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.gray.opacity(0.4), .gray.opacity(0.01)],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Label("\(bookInfoItem.title.refinedTitle)", systemImage: "chevron.left")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: mainScreen.width * 0.66, alignment: .leading)
                            .lineLimit(1)
                            .padding()
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                LottieBookView()
                    .frame(width: 200, height: 200)
                
                HStack {
                    Text("완독 목표일을 설정해주세요.")
                        .font(.title3)
                    
                    Button {
                        isPresentingDateDescSheet = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }

                }
                .foregroundColor(.secondary)
                .padding(2)
                
                Text("\(selectedDate.toFormat("yyyy년 MM월 dd일 (E)", locale: Locale(identifier: "ko")))")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(2)
                
                Text("\(0)일 동안 평균 \(0)페이지를 읽어야 해요.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Menu {
                    Button {
                        selectedDate = Date() + 1.days
                    } label: {
                        Label("내일까지", systemImage: "timer")
                    }
                    
                    Button {
                        selectedDate = Date() + 7.days
                    } label: {
                        Label("일주일 이내", systemImage: "timer")
                    }

                } label: {
                    Text("날짜 변경하기")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 200, height: 35)
                        .background(.gray.opacity(0.2))
                        .clipShape(Capsule(style: .circular))
                } primaryAction: {
                    isPresentingDatePickerSheet = true
                }
                .padding(.top, 20)
                
                Spacer()
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("돌아가기")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(15)
                    }

                    Button {
                        
                    } label: {
                        Text("추가하기")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(bookInfoItem.categoryName.refinedCategory.accentColor)
                            .cornerRadius(15)
                    }
                }
                .padding([.horizontal, .bottom])
            }
        }
        .sheet(isPresented: $isPresentingDatePickerSheet) {
            DatePickerSheetView(selectedDate: $selectedDate, bookInfo: bookInfoItem)
        }
        .sheet(isPresented: $isPresentingDateDescSheet) {
            Text("Hello, World!")
                .presentationBackground(.ultraThinMaterial)
                .presentationCornerRadius(30)
                .presentationDetents([.height(500)])
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct BookAddView_Previews: PreviewProvider {
    static var previews: some View {
        BookAddView(bookInfoItem: BookInfo.Item.preview[0])
    }
}
