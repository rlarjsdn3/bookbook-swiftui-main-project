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
    
    var body: some View {
        VStack {
            Text("축하합니다!")
                .font(.title.weight(.bold))
            
            Text("\(readingBook.title) 도서를 완독했어요!")
                .font(.headline)
                .foregroundColor(Color.secondary)
            
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
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                counter += 1
            }
        }
        .confettiCannon(counter: $counter)
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
