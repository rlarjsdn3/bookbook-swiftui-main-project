//
//  TargetBookDetailCoverView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/01.
//

import SwiftUI
import SwiftDate
import RealmSwift

struct TargetBookDetailCoverView: View {
    let targetBook: CompleteTargetBook
    
    var body: some View {
        HStack {
            asyncImage(url: targetBook.cover)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(targetBook.title)
                    .font(.title3.weight(.bold))
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                VStack(alignment: .leading) {
                    Text(targetBook.author)
                        .font(.body.weight(.semibold))
                    
                    HStack(spacing: 2) {
                        Text(targetBook.publisher)
                        
                        Text("・")
                        
                        Text(targetBook.category.rawValue)
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("50")
                                .font(.largeTitle)
                            Text("/")
                                .font(.title2.weight(.light))
                                .foregroundColor(.secondary)
                            VStack(alignment: .leading) {
                                Text("\(targetBook.itemPage)")
                                    .font(.callout).foregroundColor(.secondary)
                                    .minimumScaleFactor(0.5)
                                Text("페이지")
                                    .font(.system(size: 11)).foregroundColor(.secondary)
                            }
                        }
                        
                        Text("오늘 10페이지 읽음")
                            .font(.caption2.weight(.light))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Gauge(value: 0.5) {
                        Text("Label")
                    } currentValueLabel: {
                        Text("50%")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .scaleEffect(1.2)
                    .tint(targetBook.category.accentColor.gradient)
                }
            }
            .padding()
            
            Spacer()
        }
        .frame(height: 200)
        
    }
}

extension TargetBookDetailCoverView {
    func asyncImage(url: String) -> some View {
        AsyncImage(url: URL(string: url),
                   transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 180)
                    .clipShape(
                        CoverShape()
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
            .frame(width: 130, height: 180)
            .shimmering()
    }
}

struct TargetBookDetailCoverView_Previews: PreviewProvider {
    @ObservedResults(CompleteTargetBook.self) static var completeTargetBooks
    
    static var previews: some View {
        TargetBookDetailCoverView(targetBook: completeTargetBooks[0])
    }
}
