//
//  ViewModel.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import Foundation
import Alamofire

class BookViewModel: ObservableObject {
    
    // MARK: - WRAPPER PROPERTIES
    
    @Published var bestSeller: [BookList.Item] = []     // 베스트셀러 리스트를 저장하는 변수
    @Published var itemNewAll: [BookList.Item] = []     // 신간 도서 리스트를 저장하는 변수
    @Published var itemNewSpecial: [BookList.Item] = [] // 신간 베스트 리스트를 저장하는 변수
    @Published var blogBest: [BookList.Item] = []       // 블로그 베스트 리스트를 저장하는 변수
    
    @Published var bookSearchItems: [BookList.Item] = [] // 검색 결과 리스트를 저장하는 변수
    @Published var bookDetailInfo: [BookDetail.Item] = []  // 상세 도서 결과값을 저장하는 변수
    
    @Published var categories: [Category] = [.all] // 도서 카테고리 분류 정보를 저장하는 변수
    
    // MARK: - FUNCTIONS
    
    func setCategory() {
        var categories: [Category] = []
        
        // 중복되지 않게 카테고리 항목 저장하기
        for item in bookSearchItems where !categories.contains(item.category) {
            categories.append(item.category)
        }
        // 카테고리 항목에 '기타'가 있다면
        if let index = categories.firstIndex(of: .etc) {
            categories.remove(at: index)
            // 카테고리 이름을 오름차순(가, 나, 다)으로 정렬하기
            categories.sort {
                $0.rawValue < $1.rawValue
            }
            // '기타'를 제일 뒤로 보내기
            categories.append(.etc)
        }
        
        // 카테고리의 첫 번째에 '전체' 항목 추가하기
        categories.insert(.all, at: 0)
        
        self.categories = categories
    }
    
    /// 알라딘 리스트 API를 호출하여 도서 리스트(베스트셀러 등) 결과를 반환하는 함수입니다,
    /// - Parameter query: 도서 리스트 출력 타입
    func requestBookListAPI(type queryType: ListType) {
        var baseURL = "http://www.aladin.co.kr/ttb/api/ItemList.aspx?"
        
        let parameters = [
            "ttbKey": "\(AladinAPI.TTBKey)",
            "QueryType": "\(queryType.rawValue)",
            "Cover": "BIG",
            "MaxResults": "50",
            "start": "1",
            "SearchTarget": "Book",
            "output": "js",
            "Version": "20131101"
        ]
        
        for (key, value) in parameters {
            baseURL += "\(key)=\(value)&"
        }

        AF.request(
            baseURL,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil
        )
        .validate(statusCode: 200...500)
        .responseDecodable(of: BookList.self) { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    switch queryType {
                    case .bestSeller:
                        self.bestSeller = data.item
                    case .itemNewAll:
                        self.itemNewAll = data.item
                    case .itemNewSpecial:
                        self.itemNewSpecial = data.item
                    case .blogBest:
                        self.blogBest = data.item
                    }
                }
                print(data)
            case .failure(let error):
                print("알라딘 리스트 API 호출 실패: \(error)")
            }
        }
    }
    
    /// 알라딘 검색 API를 호출하여 도서 검색 결과를 반환하는 함수입니다,
    /// - Parameter query: 검색할 도서/저자 명
    /// - Parameter page: 검색 결과 페이지
    func requestBookSearchAPI(query: String, page startIndex: Int = 1) {
        var baseURL = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?"
        
        let parameters = [
            "ttbKey": "\(AladinAPI.TTBKey)",
            "Query": "\(euckrEncoding(query))",
            "InputEncoding": "euc-kr",
            "Cover": "BIG",
            "MaxResults": "100",
            "start": "\(startIndex)",
            "SearchTarget": "Book",
            "output": "js",
            "Version": "20131101"
        ]
        
        for (key, value) in parameters {
            baseURL += "\(key)=\(value)&"
        }

        AF.request(
            baseURL,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil
        )
        .validate(statusCode: 200...500)
        .responseDecodable(of: BookList.self) { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    DispatchQueue.main.async {
                        print(data)
                        // 다른 도서를 새로 검색한다면 검색 결과 배열 초기화하기
                        if startIndex == 1 {
                            self.bookSearchItems.removeAll()
                        }
                        self.bookSearchItems.append(contentsOf: data.item)
                        self.setCategory()
                    }
                }
            case .failure(let error):
                print("알라딘 검색 API 호출 실패: \(error)")
            }
        }
        
    }
    
    /// 알라딘 상품 API를 호출하여 상세 도서 정보를 반환하는 함수입니다,
    /// - Parameter isbn: 상세 보고자 하는 도서의 ISBN-13 값
    func requestBookDetailAPI(isbn13 isbn: String) {
        var baseURL = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?"
        
        let parameters = [
            "ttbKey": "\(AladinAPI.TTBKey)",
            "itemType": "ISBN",
            "Cover": "BIG",
            "ItemID": "\(isbn)",
            "output": "js",
            "Version": "20131101"
        ]
        
        for (key, value) in parameters {
            baseURL += "\(key)=\(value)&"
        }
        
        AF.request(
            baseURL,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil
        )
        .responseDecodable(of: BookDetail.self) { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    print(data)
                    DispatchQueue.main.async {
                        self.bookDetailInfo = data.item
                    }
                }
            case .failure(let error):
                print("알라딘 상품 API 호출 실패: \(error)")
            }
        }
    }
    
    
    /// 문자열을 euc-kr 방식으로 인코딩한 결과값을 반환하는 함수 (코드 출처: https://url.kr/spleh9)
    func euckrEncoding(_ query: String) -> String {
        let rawEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))
        let encoding = String.Encoding(rawValue: rawEncoding)

        let eucKRStringData = query.data(using: encoding) ?? Data()
        let outputQuery = eucKRStringData.map {byte->String in
            if byte >= UInt8(ascii: "A") && byte <= UInt8(ascii: "Z")
                || byte >= UInt8(ascii: "a") && byte <= UInt8(ascii: "z")
                || byte >= UInt8(ascii: "0") && byte <= UInt8(ascii: "9")
                || byte == UInt8(ascii: "_") || byte == UInt8(ascii: ".") || byte == UInt8(ascii: "-")
            {
                return String(Character(UnicodeScalar(UInt32(byte))!))
            } else if byte == UInt8(ascii: " ") {
                return "+"
            } else {
                return String(format: "%%%02X", byte)
            }
            }.joined()

        return outputQuery
    }
}
