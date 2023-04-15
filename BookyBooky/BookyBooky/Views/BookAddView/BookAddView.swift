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
    
    @State private var selectedDate: Date = Date()
    
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
                
                LottieView()
                
                Spacer()
                
                Text("\(selectedDate.toFormat("yyyy년 MM월 dd일 (E)", locale: Locale(identifier: "ko")))")
                
                Menu {
                    
                } label: {
                    Text("날짜 변경하기")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(.black)
                        .cornerRadius(15)
                } primaryAction: {
                    isPresentingDatePickerSheet = true
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $isPresentingDatePickerSheet) {
            DatePickerSheetView(selectedDate: $selectedDate, bookInfo: bookInfoItem)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct BookAddView_Previews: PreviewProvider {
    static var previews: some View {
        BookAddView(bookInfoItem: BookInfo.Item.preview[0])
    }
}
