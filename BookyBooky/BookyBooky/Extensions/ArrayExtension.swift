//
//  ArrayExtension.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/05/19.
//

import Foundation

extension Array<ReadingBook> {
    func getReadingBookCategoryType() -> [Category] {
        var categoryTypes: [Category] = [.all]
        
        for book in self where !categoryTypes.contains(book.category) && !book.isComplete {
            categoryTypes.append(book.category)
        }
        
        return categoryTypes
    }
}
