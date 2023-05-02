//
//  TargetBookCellView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct TargetBookCellView: View {
    
    @ObservedRealmObject var targetBook: ReadingBook
    
    @Binding var selectedCategory: Category
    
    @State private var isPresentingTargetBookDetailView = false
    @State private var isLoading = true
    
    // MARK: - COMPUTED PROPERTIES
    
    var targetBookProgressValue: Double {
        if let readingRecord = targetBook.readingRecords.last {
            return Double(readingRecord.totalPagesRead) / Double(targetBook.itemPage) * 100.0
        } else {
            return 99.0
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            asyncImage(url: targetBook.cover)

            progressBar
            
            targetBookTitle
            
            targetBookAuthor
        }
        .frame(width: 150)
        .padding(.horizontal, 10)
        .navigationDestination(isPresented: $isPresentingTargetBookDetailView) {
            TargetBookDetailView(readingBook: targetBook)
        }
        .onTapGesture {
            isPresentingTargetBookDetailView = true
        }
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
    
    var progressBar: some View {
        HStack {
            ProgressView(value: targetBookProgressValue, total: 100.0)
                .tint(Color.black.gradient)
                .frame(width: 100, alignment: .leading)
            
            Text("\(Int(targetBookProgressValue))%")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    var targetBookTitle: some View {
        Text("\(targetBook.title)")
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(width: 150, height: 25)
            .padding(.horizontal)
            .padding([.top, .bottom], -5)
    }
    
    var targetBookAuthor: some View {
        Text("\(targetBook.author)")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
}

struct TargetBookCellView_Previews: PreviewProvider {
    @ObservedResults(ReadingBook.self) static var completeTargetBooks
    
    static var previews: some View {
        TargetBookCellView(targetBook: completeTargetBooks[0], selectedCategory: .constant(.all))
    }
}
