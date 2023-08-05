//
//  ViewModel.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI
import Alamofire
import AlertToast

final class AladinAPIManager: ObservableObject {
     
    // MARK: - ALADIN API FUNCTIONS
    
    /// 알라딘 리스트 API를 호출하여 도서 리스트(베스트셀러 등) 결과를 반환하는 함수입니다. 해당 작업은 비동기적으로 처리됩니다.
    /// - Parameter type: 도서 리스트 타입
    func requestBookList(of type: BookListType, completionHandler: @escaping (SimpleBookInfo?) -> Void) {
        // 알라딘 API 기초 주소 초가화
        var baseUrl = "http://www.aladin.co.kr/ttb/api/ItemList.aspx?"
        // API 호출에 필요한 쿼리 파라미터 초기화
        let parameters = [
            "ttbKey": "\(AladinAPI.TTBKey)",
            "QueryType": "\(type.rawValue)",
            "Cover": "BIG",
            "MaxResults": "50",
            "start": "1",
            "SearchTarget": "Book",
            "output": "js",
            "Version": "20131101"
        ]
        // 기초 주소에 쿼리 파라미터 대입
        for (key, value) in parameters {
            baseUrl += "\(key)=\(value)&"
        }
        // 만들어진 주소를 URL 구조체로 래핑
        let url = URL(string: baseUrl)!
        // HTTP 통신을 비동기적으로 수행
        performURLRequest(of: SimpleBookInfo.self, url: url) { book in
            completionHandler(book)
        }
    }
    
    /// 알라딘 검색 API를 호출하여 도서 검색 결과를 반환하는 함수입니다. 해당 작업은 비동기적으로 처리됩니다.
    /// - Parameter query: 검색할 도서/저자 명
    /// - Parameter page: 검색 결과 페이지(기본값: 1)
    func requestBookSearchResult(_ query: String, page index: Int = 1, completionHandler: @escaping (SimpleBookInfo?) -> Void) {
        // 검색어가 빈 문자열이면 반환
        guard !query.isEmpty else { return }
        // 알라딘 API 기초 주소 초기화
        var baseUrl = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?"
        // API 호출에 필요한 쿼리 파라미터 초기화
        let parameters = [
            "ttbKey": "\(AladinAPI.TTBKey)",
            "Query": "\(query.euckrEncoding)",
            "InputEncoding": "euc-kr",
            "Cover": "BIG",
            "MaxResults": "50",
            "start": "\(index)",
            "SearchTarget": "Book",
            "output": "js",
            "Version": "20131101"
        ]
        // 기초 주소에 쿼리 파라미터 대입
        for (key, value) in parameters {
            baseUrl += "\(key)=\(value)&"
        }
        // 만들어진 주소를 URL 구조체로 래핑
        let url = URL(string: baseUrl)!
        // HTTP 통신을 비동기적으로 수행
        performURLRequest(of: SimpleBookInfo.self, url: url) { book in
            completionHandler(book)
        }
    }
    
    /// 알라딘 상품 API를 호출하여 상세 도서 정보를 반환하는 함수입니다. 해당 작업은 비동기적으로 처리됩니다.
    /// - Parameter isbn: ISBN13
    func requestBookDetailInfo(_ isbn: String, completionHandler: @escaping (DetailBookInfo?) -> Void) {
        // 알라딘 API 기초 주소 초기화
        var baseUrl = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?"
        // API 호출에 필요한 쿼리 파라미터 초기화
        let parameters = [
            "ttbKey": "\(AladinAPI.TTBKey)",
            "itemType": "ISBN",
            "Cover": "BIG",
            "ItemID": "\(isbn)",
            "output": "js",
            "Version": "20131101"
        ]
        // 기초 주소에 쿼리 파라미터 대입
        for (key, value) in parameters {
            baseUrl += "\(key)=\(value)&"
        }
        // 만들어진 주소를 URL 구조체로 래핑
        let url = URL(string: baseUrl)!
        // HTTP 통신을 비동기적으로 수행
        performURLRequest(of: DetailBookInfo.self, url: url) { book in
            completionHandler(book)
        }
    }
    
    private func performURLRequest<T: Decodable>(of type: T.Type, url: URL, completionHandler: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // 에러가 없는지 확인
            if error != nil {
                completionHandler(nil)
                return
            }
            // 상태 코드가 200이상 300미만인지 확인
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if !(200..<300).contains(statusCode) {
                    completionHandler(nil)
                    return
                }
            }
            // JSON을 구조체로 파싱
            if let data = data {
                let parsedData = self.decode(of: T.self, data: data)
                completionHandler(parsedData)
            }
        }.resume()
    }
    
    private func decode<T: Decodable>(of type: T.Type, data: Data) -> T? {
        do {
            let parsedData = try JSONDecoder().decode(type, from: data)
            return parsedData
        } catch let error {
            print("JSON 파싱 실패: \(error)")
            return nil
        }
    }
}
