//
//  BookSearch.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import Foundation
import SwiftDate

// MARK: - STRUCT

struct BookList: Codable {
    var totalResults: Int           // 검색 결과의 총 개수
    var startIndex: Int             // 현재 페이지 수
    
    var item: [Item]
    struct Item: Codable, Hashable {
        var title: String           // 제목
        var author: String          // 저자
        var publisher: String       // 출판사
        var pubDate: String         // 출판일
        var cover: String           // 커버(표지)
        var categoryName: String    // 카테고리 분류
        var isbn13: String          // ISBN-13
    }
}

// MARK: - EXTENSIONS

extension BookList.Item {
    static var preview: [BookList.Item] {
        [
            .init(
                title: "Java의 정석 - 3rd Edition",
                author: "남궁성 (지은이)",
                publisher: "도우출판",
                pubDate: "2016-01-28",
                cover: "https://image.aladin.co.kr/product/22460/28/cover/8994492046_1.jpg",
                categoryName: "국내도서>컴퓨터/모바일>프로그래밍 언어>자바",
                isbn13: "9788994492049"
            )
        ]
    }
}

extension BookList.Item {
    /// 도서 제목을 반환하는 프로퍼티
    var originalTitle: String {
        return String(title.split(separator: " - ")[0])
    }
    
    /// 도서 부제를 반환하는 프로퍼티 (부제 없을 시, 빈 문자열 반환)
    var subTitle: String {
        let titles = title.split(separator: " - ")
        if titles.count > 1 {
            return String(titles[1])
        }
        return ""
    }
    
    /// 저자 정보를 반환하는 프로퍼티
    var authorInfo: String {
        let writer = author.split(separator: " (지은이)").map { String($0) }
        // 저자 정보가 ' (지은이)'를 기준으로 제대로 나누어지면
        if writer.count > 1 {
            // 복수 저자가 있으면
            let writers = writer[0].split(separator: ", ").map { String($0) }
            if writers.count > 1 {
                return writers[0] + "외 \(writers.count - 1)명"
            }
            return writers[0]
        // 저자 정보가 제대로 나누어지지 못하면
        } else {
            return author.split(separator: " ").map { String($0) }[0]
        }
    }
    
    var publishDate: Date {
        if let date = pubDate.toDate() {
            return date.date
        } else {
            return Date()
        }
    }
    
    /// 1차 카테고리 분류 정보를 반환하는 프로퍼티
    var oneDepthCategoryName: String {
        let category = categoryName.split(separator: ">")
        if category.count > 1 {
            return String(category[1])
        }
        return "기타" // '기타'로 분류
    }
    
    /// 1차 카테고리 분류 정보를 기반으로 앱 내부에 출력될 카테고리 정보를 반환하는 프로퍼티(카테고리 정제)
    var category: Category {
        switch oneDepthCategoryName {
        case "액션/어드벤처":
            return .action
        case "전기/자서전":
            return .autobiography
        case "만화":
            return .cartoon
        case "어린이":
            return .children
        case "중국 도서":
            return .chinese
        case "고전", "고전/명작":
            return .classic
        case "유머":
            return .comedy
        case "컴퓨터/모바일", "컴퓨터":
            return .computer
        case "요리":
            return .cook
        case "공예/취미/수집":
            return .craft
        case "인물/평전":
            return .criticalBiography
        case "건축/디자인":
            return .design
        case "교양/다큐멘터리":
            return .documentary
        case "경제경영":
            return .economic
        case "교육/자료":
            return .education
        case "초등학교참고서", "초등참고서":
            return .elementarySchool
        case "ELT/어학/사전":
            return .elt
        case "에세이":
            return .essay
        case "수험서/자격증", "수험서":
            return .examination
        case "가족/관계", "좋은부모":
            return .family
        case "S.F/판타지", "판타지/무협":
            return .fantasy
        case "외국어":
            return .foreignLanguage
        case "게임/토이":
            return .game
        case "장르소설":
            return .genreNovel
        case "건강/취미/레저":
            return .habit
        case "건강/취미":
            return .health
        case "스포츠":
            return .sports
        case "고등학교참고서", "중고등참고서":
            return .highSchool
        case "역사":
            return .history
        case "인문학":
            return .humanities
        case "가정/원예/인테리어":
            return .interior
        case "일본 도서":
            return .japanese
        case "한국관련도서":
            return .korea
        case "법률":
            return .law
        case "가정/요리/뷰티":
            return .life
        case "라이트 노벨":
            return .lightNovel
        case "언어학":
            return .linguistic
        case "잡지", "해외잡지":
            return .magazine
        case "의학":
            return .medical
        case "중학교참고서":
            return .middleSchool
        case "자연과학":
            return .naturalScience
        case "소설/시/희곡":
            return .poem
        case "예술/대중문화":
            return .culture
        case "대학교재/전문서적", "대학교재":
            return .professional
        case "종교/역학", "종교/명상/기타", "종교/명상/점술":
            return .religion
        case "로맨스":
            return .romance
        case "과학":
            return .science
        case "자기계발":
            return .selfImprovement
        case "사회과학":
            return .socialScience
        case "인문/사회":
            return .society
        case "취미/스포츠":
            return .sports
        case "기술공학":
            return .technical
        case "공포/스릴러":
            return .thriller
        case "유아", "유아/아동":
            return .toddler
        case "여행":
            return .travel
        default:
            return .etc
        }
    }
}
