//
//  TargetBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct TargetBookCellView: View {
    
    @ObservedRealmObject var targetBook: CompleteTargetBook
    
    @Binding var selectedCategory: Category
    
    @State private var isPresentingTargetBookDetailView = false
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            asyncImage(url: targetBook.cover)
            
            HStack {
                ProgressView(value: 0.5)
                    .tint(Color.black.gradient)
                    .frame(width: 100, alignment: .leading)
                
                Text("50%")
                    .font(.subheadline)
            }
            
            Text("\(targetBook.title)")
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(width: 150, height: 25)
                .padding(.horizontal)
                .padding([.top ,.bottom], -5)
            
            Text("\(targetBook.author)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(width: 150)
        .padding(.horizontal, 10)
        .onTapGesture {
            isPresentingTargetBookDetailView = true
        }
        .navigationDestination(isPresented: $isPresentingTargetBookDetailView) {
            HomeTargetBookDetailView(targetBook: targetBook)
        }
        
//        VStack {
//            ForEach(filteredCompleteTargetBooks) { targetBook in
//                HStack {
//                    asyncImage(url: targetBook.cover)
//
//                    VStack(alignment: .leading, spacing: 3) {
//                        Text("\(targetBook.title)")
//                            .font(.title3)
//                            .fontWeight(.bold)
//                            .lineLimit(1)
//
//                        VStack(alignment: .leading, spacing: 0) {
//                            Text("\(targetBook.author)")
//                                .fontWeight(.semibold)
//
//                            HStack(spacing: 3) {
//                                Text("\(targetBook.publisher)")
//                                Text("・")
//                                Text("\(targetBook.category.rawValue)")
//                            }
//                            .font(.callout)
//                            .foregroundColor(.secondary)
//                            .lineLimit(1)
//                        }
//
//                        Spacer()
//
//                        HStack(alignment: .center) {
//                            // 기한이 오늘까지인 경우, 내일까지인 경우 예외 처리 코드 작성하기
//                            Text("\(targetBook.targetDate.toFormat("yyyy년 MM월 dd일"))까지 (\(Int(targetBook.targetDate.timeIntervalSince(targetBook.startDate) / 86400.0))일 남음)")
//
//                            Spacer(minLength: 0)
//
//                            // 디자인 다시 고민해보기
//                            Text("50%")
//                                .font(.body)
//                        }
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//
//
//                        Gauge(value: 0.5) {
//                            Text("독서량")
//                        }
//                        .gaugeStyle(.accessoryLinear)
//                        .tint(Gradient(colors: [.gray, .black]))
//                    }
//                    .padding(5)
//
//                    Spacer()
//                }
//                .padding(5)
//                .background(Color("Background"))
//                .cornerRadius(10)
//                .padding(.horizontal)
//                .padding(.top, 5)
//            }
//        }
//        .padding(.bottom, 30)
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
                    .frame(width: 150, height: 200)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 15,
                            style: .continuous
                        )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: -5, y: 5)
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
            .frame(width: 150, height: 200)
            .shimmering()
    }
}

struct TargetBookCellView_Previews: PreviewProvider {
    @ObservedResults(CompleteTargetBook.self) static var completeTargetBooks
    
    static var previews: some View {
        TargetBookCellView(targetBook: completeTargetBooks[0], selectedCategory: .constant(.all))
    }
}
