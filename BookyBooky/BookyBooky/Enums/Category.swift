//
//  BookCategory.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI
import RealmSwift

/// 애플리케이션 내부에 출력되는 카테고리 열거형입니다.
enum Category: String, PersistableEnum {
    case all, action, autobiography
    case cartoon, children, chinese, classic, comedy, computer, cook, craft, criticalBiography, culture
    case design, documentary
    case economic, education, elementarySchool, elt, essay, examination
    case family, fantasy, foreignLanguage
    case game, genreNovel
    case habit, health, highSchool, history, humanities
    case interior
    case japanese
    case korea
    case law, life, lightNovel, linguistic
    case magazine, medical, middleSchool
    case naturalScience
    case poem, professional
    case religion, romance
    case science, selfImprovement, socialScience, society, sports
    case technical, teenager, thriller, toddler, travel
    case etc

    /// 실제 화면에 표시될 카테고리 명을 반환하는 프로퍼티입니다.
    var name: String {
        switch self {
        case .all:
            return "전체"
        case .action:
            return "액션・어드벤처"
        case .autobiography:
            return "전기・자서전"
        case .cartoon:
            return "만화"
        case .children:
            return "어린이"
        case .chinese:
            return "중국 도서"
        case .classic:
            return "고전"
        case .comedy:
            return "유머"
        case .computer:
            return "IT・컴퓨터"
        case .cook:
            return "요리・살림"
        case .craft:
            return "공예・취미"
        case .criticalBiography:
            return "인물・평전"
        case .design:
            return "건축・디자인"
        case .documentary:
            return "교양"
        case .economic:
            return "경제・경영"
        case .education:
            return "교육・자료"
        case .elementarySchool:
            return "초등참고서"
        case .elt:
            return "어학・사전"
        case .essay:
            return "에세이"
        case .examination:
            return "수험서・자격증"
        case .family:
            return "가족・관계"
        case .fantasy:
            return "무협・판타지"
        case .foreignLanguage:
            return "외국어"
        case .game:
            return "게임・토이"
        case .genreNovel:
            return "게임・토이"
        case .habit:
            return "취미・레저"
        case .health:
            return "건강・취미"
        case .highSchool:
            return "고등참고서"
        case .history:
            return "역사"
        case .humanities:
            return "인문학"
        case .interior:
            return "원예・인테리어"
        case .japanese:
            return "일본 도서"
        case .korea:
            return "대한민국"
        case .law:
            return "법률"
        case .life:
            return "가정・요리"
        case .lightNovel:
            return "라이트노벨"
        case .linguistic:
            return "언어학"
        case .magazine:
            return "잡지"
        case .medical:
            return "의학"
        case .middleSchool:
            return "중등참고서"
        case .naturalScience:
            return "자연과학"
        case .poem:
            return "소설・시"
        case .culture:
            return "예술・대중문화"
        case .professional:
            return "전문서적"
        case .religion:
            return "종교/명상"
        case .romance:
            return "로맨스"
        case .science:
            return "과학"
        case .selfImprovement:
            return "자기계발"
        case .socialScience:
            return "사회과학"
        case .society:
            return "인문・사회"
        case .sports:
            return "건강・스포츠"
        case .technical:
            return "기술공학"
        case .teenager:
            return "청소년"
        case .thriller:
            return "공포・스릴러"
        case .toddler:
            return "유아"
        case .travel:
            return "여행"
        case .etc:
            return "기타"
        }
    }
    
    /// 도서 분야 별 전경(텍스트) 색상 정보를 반환하는 프로퍼티입니다.
    var foregroundColor: Color {
        switch self {
        case .computer, .naturalScience, .science, .socialScience, .technical:
            return .white
        default:
            return .black
        }
    }
    
    /// 도서 분야 별 테마 색상 정보를 반환하는 프로퍼티입니다.
    var themeColor: Color {
        switch self {
        case .computer, .naturalScience, .science, .socialScience, .technical:
            return .black
        case .economic, .law, .linguistic, .medical, .professional:
            return .blue
        case .classic, .history, .religion:
            return .brown
        case .sports, .travel:
            return .cyan
        case .cook, .craft, .family, .habit, .health, .life:
            return .green
        case .elt, .examination, .foreignLanguage:
            return .indigo
        case .documentary, .education, .selfImprovement:
            return .mint
        case .elementarySchool, .middleSchool, .highSchool, .teenager:
            return .orange
        case .romance:
            return .pink
        case .action, .essay, .fantasy, .genreNovel, .lightNovel, .poem, .thriller:
            return .purple
        case .design, .interior, .culture:
            return .red
        case .autobiography, .criticalBiography, .humanities:
            return .teal
        case .cartoon, .children, .comedy, .game, .toddler:
            return .yellow
        case .korea:
            return .primary
        default:
            return .gray
        }
    }
}


