//
//  TargetBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct TargetBookCellView: View {
    
    @ObservedResults(CompleteTargetBook.self) var completeTargetBooks
    
    @Binding var selectedCategory: Category
    
    @State private var isLoading = true
    
    var filteredCompleteTargetBooks: [CompleteTargetBook] {
        var filteredBooks: [CompleteTargetBook] = []
        
        // 애니메이션이 없는 변수로 코드 수정하기
        if selectedCategory == .all {
            return Array(completeTargetBooks)
        } else {
            for book in completeTargetBooks where selectedCategory == book.category {
                filteredBooks.append(book)
            }
            
            return filteredBooks
        }
    }
    
    var body: some View {
        VStack {
            ForEach(filteredCompleteTargetBooks) { targetBook in
                HStack {
                    asyncImage(url: targetBook.cover)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(targetBook.title)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(targetBook.author)")
                                .fontWeight(.semibold)
                            
                            HStack(spacing: 3) {
                                Text("\(targetBook.publisher)")
                                Text("・")
                                Text("\(targetBook.category.rawValue)")
                            }
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        HStack(alignment: .center) {
                            // 기한이 오늘까지인 경우, 내일까지인 경우 예외 처리 코드 작성하기
                            Text("\(targetBook.targetDate.toFormat("yyyy년 MM월 dd일"))까지 (\(Int(targetBook.targetDate.timeIntervalSince(targetBook.startDate) / 86400.0))일 남음)")
                            
                            Spacer(minLength: 0)
                            
                            // 디자인 다시 고민해보기
                            Text("50%")
                                .font(.body)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        
                        
                        Gauge(value: 0.5) {
                            Text("독서량")
                        }
                        .gaugeStyle(.accessoryLinear)
                        .tint(Gradient(colors: [.gray, .black]))
                    }
                    .padding(5)
                    
                    Spacer()
                }
                .padding(5)
                .background(Color("Background"))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 5)
            }
        }
        .padding(.bottom, 30)
    }
}

extension TargetBookCellView {
    func asyncImage(url: String) -> some View {
        AsyncImage(url: URL(string: url),
                   transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 120)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 6,
                            style: .continuous
                        )
                    )
                    .onAppear {
                        isLoading = false
                    }
            case .empty:
                loadingCover
            case .failure(_):
                loadingCover
            @unknown default:
                loadingCover
            }
        }
    }
    
    var loadingCover: some View {
        Rectangle()
            .fill(.gray.opacity(0.2))
            .frame(width: 80, height: 120)
            .shimmering()
    }
}

struct TargetBookCellView_Previews: PreviewProvider {
    static var previews: some View {
        TargetBookCellView(selectedCategory: .constant(.all))
    }
}
