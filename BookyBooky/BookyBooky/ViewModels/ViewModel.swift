//
//  ViewModel.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import Foundation
import Alamofire

class ViewModel: ObservableObject {
    @Published var bookItemList: BookList?     // 도서 리스트를 저장하는 변수
    @Published var bookSearchList: BookSearch? // 검색 결과 리스트를 저장하는 변수
    @Published var bookDetailList: BookDetail? // 상세 도서 결과값을 저장하는 변수
    
    @Published var bookCategory: [BookCategory]? // 도서 카테고리 정보를 저장하는 변수
    
    func getBookCategory() {
        var category: [BookCategory] = [.all]
        
        if let bookSearchList = bookSearchList {
            for item in bookSearchList.item {
                if !category.contains(item.category) {
                    category.append(item.category)
                }
            }
        }
        
        print(category) // 디버그 - 도서 카테고리 정보 출력
        bookCategory = category
    }
    
    /// 알라딘 리스트 API를 호출하여 도서 리스트(베스트셀러 등) 결과를 반환하는 함수입니다,
    /// - Parameter query: 도서 리스트 출력 타입
    func requestBookListAPI(type queryType: BookListType) {
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
                    DispatchQueue.main.async {
                        self.bookItemList = data
                        print(data) // 디버그 - 검색 결과 데이터 콘솔 출력
                    }
                }
            case .failure(let error):
                print("알라딘 리스트 API 호출 실패: \(error)")
            }
        }
    }
    
    /// 알라딘 검색 API를 호출하여 도서 검색 결과를 반환하는 함수입니다,
    /// - Parameter query: 검색할 도서/저자 명
    func requestBookSearchAPI(search query: String) {
        var baseURL = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?"
        
        let parameters = [
            "ttbKey": "\(AladinAPI.TTBKey)",
            "Query": "\(euckrEncoding(query))",
            "InputEncoding": "euc-kr",
            "QueryType": "Title",
            "Cover": "BIG",
            "MaxResults": "100",
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
        .responseDecodable(of: BookSearch.self) { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    DispatchQueue.main.async {
                        self.bookSearchList = data
                        self.getBookCategory()
                        print(data) // 디버그 - 검색 결과 데이터 콘솔 출력
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
                    DispatchQueue.main.async {
                        self.bookDetailList = data
                        print(data) // 디버그 - 검색 결과 데이터 콘솔 출력
                    }
                }
            case .failure(let error):
                print("알라딘 상품 API 호출 실패: \(error)")
            }
        }
        
        
    }
    
    
    /// 코드 출처: StackOverflow(https://url.kr/spleh9)
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
