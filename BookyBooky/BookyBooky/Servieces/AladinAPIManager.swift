//
//  ViewModel.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/28.
//

import SwiftUI
import Alamofire
import AlertToast

class AladinAPIManager: ObservableObject {
    
    @Published var searchResults: [briefBookItem.Item] = [] // 검색 결과 리스트를 저장하는 변수
    @Published var searchBookInfo: detailBookItem.Item?     // 상세 도서 결과값을 저장하는 변수
    
    // MARK: - ALADIN API FUNCTIONS
    
    /// 알라딘 리스트 API를 호출하여 도서 리스트(베스트셀러 등) 결과를 반환하는 함수입니다,
    /// - Parameter query: 도서 리스트 출력 타입
    func requestBookListAPI(of type: BookListTab, completionHandler: @escaping (briefBookItem?) -> Void) {
        // 알라딘 API 기초 주소 초가화
        var baseUrl = "http://www.aladin.co.kr/ttb/api/ItemList.aspx?"
        // API 호출에 필요한 쿼리 파라미터 정의
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
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // 에러가 없는지 확인
            if error != nil {
                completionHandler(nil)
                print("에러")
                return
            }
            // 상태 코드가 200이상 300미만인지 확인
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if !(200..<300).contains(statusCode) {
                    completionHandler(nil)
                    print("상태코드")
                    return
                }
            }
            // JSON을 구조체로 파싱
            if let data = data {
                let parsedData = self.decode(of: briefBookItem.self, data: data)
                completionHandler(parsedData)
            }
        }.resume()
    }
    
    /// 알라딘 검색 API를 호출하여 도서 검색 결과를 반환하는 함수입니다,
    /// - Parameter query: 검색할 도서/저자 명
    /// - Parameter page: 검색 결과 페이지(기본값 = 1)
    func requestBookSearchAPI(_ query: String, page index: Int = 1) {
        guard !query.isEmpty else { return }
        
        var baseURL = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?"
        
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
        .responseDecodable(of: briefBookItem.self) { response in
            switch response.result {
            case .success(let results):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    if index == 1 {
                        self.searchResults.removeAll()
                    }

                        self.searchResults.append(contentsOf: results.item)
                }
            case .failure(let error):
                print("알라딘 검색 API 호출 실패: \(error)")
            }
        }
    }
    
    /// 알라딘 상품 API를 호출하여 상세 도서 정보를 반환하는 함수입니다,
    /// - Parameter isbn: 상세 보고자 하는 도서의 ISBN-13 값
    func requestBookDetailAPI(_ isbn: String) {
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
        .responseDecodable(of: detailBookItem.self) { response in
            switch response.result {
            case .success(let detailBookInfo):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        self.searchBookInfo = detailBookInfo.item[0]
                    }
                }
            case .failure(let error):
                print("알라딘 상품 API 호출 실패: \(error)")
//                self.isPresentingDetailBookErrorToastAlert = true
            }
        }
    }
    
    func decode<T: Decodable>(of type: T.Type, data: Data) -> T? {
        do {
            let parsedData = try JSONDecoder().decode(type, from: data)
            return parsedData
        } catch let error {
            print("JSON 파싱 실패: \(error)")
            return nil
        }
    }
}
