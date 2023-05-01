//
//  HomeTargetBookDetailView.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/04/27.
//

import SwiftUI
import RealmSwift

struct TargetBookDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedRealmObject var targetBook: CompleteTargetBook
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Text(targetBook.title)
                    .lineLimit(1)
                    .truncationMode(.middle)
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
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .navigationBarItemStyle()
                    }
                }
            }
            .padding(.vertical)
            
            ScrollView {
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
                
                HStack {
                    Button {
                        // do something...
                    } label: {
                        Text("읽었어요!")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 112, height: 30)
                            .background(.gray.opacity(0.3))
                            .clipShape(Capsule())
                    }
                    
                    Text("오늘 히루 10페이지를 읽었어요!")
                        .font(.caption.weight(.light))
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Spacer()
            }
            
            
            
//            Text("\(targetBook.title)")
//                .toolbar(.hidden, for: .navigationBar)
//
//            // 테스트 코드
//            Button("10페이지 읽었음!") {
//                let readingRecord = ReadingRecords(
//                    value: ["date": Date(),
//                            "totalPagesRead": 10,
//                            "numOfPagesRead": 10] as [String : Any]
//                )
//
//                $targetBook.readingRecords.append(readingRecord)
//            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension TargetBookDetailView {
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

struct HomeTargetBookDetailView_Previews: PreviewProvider {
    static let realmManager = RealmManager.openLocalRealm()
    @ObservedResults(CompleteTargetBook.self) static var completeTargetBooks
    
    static var previews: some View {
        TargetBookDetailView(targetBook: completeTargetBooks[0])
    }
}
