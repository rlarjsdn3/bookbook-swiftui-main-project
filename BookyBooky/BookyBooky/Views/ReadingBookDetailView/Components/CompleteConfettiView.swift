//
//  CompleteConfettiView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/15.
//

import SwiftUI
import RealmSwift
import ConfettiSwiftUI

struct CompleteConfettiView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedRealmObject var readingBook: ReadingBook
    
    @State private var counter = 0
    
    // MARK: - COMPUTED PROPERTIES
    
    var elapsedReadingDay: Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents(
            [.day],
            from: readingBook.startDate,
            to: readingBook.completeDate ?? Date()
        )
        return component.day!
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 5) {
            Spacer()
            
            Text("축하합니다!")
                .font(.largeTitle.weight(.bold))
            
            Text("\(readingBook.title) 도서를 완독했어요!")
                .font(.title2.weight(.semibold))
                .foregroundColor(Color.secondary)
                .padding(.bottom, 40)
            
            asyncImage(url: readingBook.cover)
            
            // 아직 미완성 코드
            Text("완독까지 \(elapsedReadingDay)일이 걸렸어요.")
                .font(.headline)
                .padding(.top, 30)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                 Text("확인")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(readingBook.category.accentColor)
                    .cornerRadius(15)
            }
            .padding(.horizontal)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                counter += 1
            }
        }
        .confettiCannon(counter: $counter, num: 80, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200, repetitions: 2, repetitionInterval: 0.5)
    }
}

extension CompleteConfettiView {
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
            case .failure(_), .empty:
                loadingImage
            @unknown default:
                loadingImage
            }
        }
    }
    
    var loadingImage: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.gray.opacity(0.2))
            .frame(width: 150, height: 200)
            .shimmering()
    }
}

struct CompleteConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteConfettiView(readingBook: ReadingBook.preview)
    }
}
