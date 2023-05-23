//
//  BookCategory.swift
//  BookyBooky
//
//  Created by 김건우 on 2023/03/29.
//

import SwiftUI
import RealmSwift

/// 실제 앱 내부에 보여지는 카테고리입니다. 원시값(rawValue)으로 카테고리 명을 출력하세요.
enum CategoryType: String, PersistableEnum {
    case all = "전체"
    case action = "액션/어드벤처"
    case autobiography = "전기/자서전"
    case cartoon = "만화"
    case children = "어린이"
    case chinese = "중국 도서"
    case classic = "고전"
    case comedy = "유머"
    case computer = "컴퓨터/모바일"
    case cook = "요리/살림"
    case craft = "공예/취미"
    case criticalBiography = "인물/평전"
    case design = "건축/디자인"
    case documentary = "교양/다큐"
    case economic = "경제/경영"
    case education = "교육/자료"
    case elementarySchool = "초등참고서"
    case elt = "어학/사전"
    case essay = "에세이"
    case examination = "수험서/자격증"
    case family = "가족/관계"
    case fantasy = "무협/판타지"
    case foreignLanguage = "외국어"
    case game = "게임/토이"
    case genreNovel = "장르소설"
    case habit = "취미/레저"
    case health = "건강/취미"
    case highSchool = "고등참고서"
    case history = "역사"
    case humanities = "인문학"
    case interior = "원예/인테리어"
    case japanese = "일본 도서"
    case korea = "한국"
    case law = "법률"
    case life = "가정/요리"
    case lightNovel = "라이트노벨"
    case linguistic = "언어학"
    case magazine = "잡지"
    case medical = "의학"
    case middleSchool = "중등참고서"
    case naturalScience = "자연과학"
    case poem = "소설/시"
    case culture = "예술/대중문화"
    case professional = "전문서적"
    case religion = "종교/명상"
    case romance = "로맨스"
    case science = "과학"
    case selfImprovement = "자기계발"
    case socialScience = "사회과학"
    case society = "인문/사회"
    case sports = "건강/스포츠"
    case technical = "기술공학"
    case teenager = "청소년"
    case thriller = "공포/스릴러"
    case toddler = "유아"
    case travel = "여행"
    case etc = "기타"
    
    /// 카테고리 별 전경 색상 정보를 반환하는 프로퍼티입니다. (Beta)
    var foregroundColor: Color {
        switch self {
        case .computer, .naturalScience, .science, .socialScience, .technical:
            return .white
        default:
            return .black
        }
    }
    
    /// 카테고리 별 강조 색상 정보를 반환하는 프로퍼티입니다. (Beta)
    var accentColor: Color {
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


