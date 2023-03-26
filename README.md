<img src="https://user-images.githubusercontent.com/21079970/224593183-bb6b4657-3521-4fd9-a478-ae578bc05503.png" align="center" width="150" height="150">

# 부키부키(BookyBooky)
## 개요

**`프로젝트 이름`** 부키부키(BookyBooky) <br>
**`프로젝트 설명`** 올바른 독서 습관을 형성하는 데에 도움을 주고, 목표를 설정하고 이를 추적하여 달성하는 과정을 돕는 앱(App) <br>
**`프로젝트 기간`** 2023. 03. 13 ~ 2023. 08. 31 (예정) <br>

> 프로젝트 진행 중으로 계획은 언제든지 변경될 수 있습니다!

## 개발 배경 및 동기

* **성인 종합 독서율의 하락**
  + 문화체육관광부에서 발표한 ⌜2021년 국민 독서실태 조사⌟에 따르면, 성인의 연간 종합 독서율이 2017년 60%에서 2021년 41%로 크게 줄어든 것으로 드러남. 아울러, 성인의 연간 독서 권수도 2017년 8권에서 2021년 5권으로 38%나 줄어듬.
  
* **독서율 하락 주범은 시간**
  + 동일한 자료에 따르면, 성인의 독서 방해 주요 요인 중 ⌜일 때문에 시간이 없어서⌟, ⌜책 읽는 습관을 들이지 않아서⌟ 항목이 순서대로 높은 비중을 차지함. 더불어, PC 및 스마트폰의 콘텐츠의 이용이 독서율 하락에 큰 비중을 차지하리라 추측됨.
  
* **전공 서적 완독율 심각**
  + 매 학기마다 전공 과목 공부를 위해 전공 서적을 구매하지만, ⌜다른 과목 공부로 시간이 없어서⌟ 등 이유로 한번도 완독을 해본 적이 없음. (본인 사례)

## 개발 환경

### 통합 개발 환경(IDE)

* Xcode 14.2

### 개발 언어 및 프레임워크

* Swift
* SwiftUI
* UIKit

### 데이터베이스

* Realm (MongoDB)

### 오픈소스 라이브러리

* Charts
* Alamofire
* RealmSwift
* SVProgressHUB
* TextFieldEffects
* Lottie-ios
* SwiftUI-Shimmer
* IceCream

### 최소 요구 사양

* iOS 16.0+

## 벤치마킹

| 번호 | 구분 | 앱 이름 | 내용 | 비고 |
| :--: | :--: | :--: | :-- | :-- |
| **1** | 국내 | 북적북적 | ▪︎ 사용자가 완독한 도서를 등록하면 완독 도서의 총 높이를 시각적으로 보여줌 <br> ▪︎ 완독한 도서의 높이에 따라 `북적이 캐릭터`를 주어 목표 의식을 가지게 만듦 <br> ▪︎ 도서 별로 도서 메모와 평점 기록 기능을 제공함 <br> ▪︎ 월 별로 완독한 도서의 권 수와 페이지를 막대 그래프로 보여줌 | |
| **2** | 국내 | 리더스 | ▪︎ 등록 도서를 ⌜읽고 싶은⌟, ⌜읽는 중⌟, ⌜읽음⌟으로 구분지을 수 있음 <br> ▪︎ 도서 별로 한줄 글귀(마크 기능)와 평점 기록 기능을 제공함 <br> ▪︎ 완독 현황을 캘린더를 이용해 시각적으로 보여줌 <br> ▪︎ 분류 별 완독 현황을 원형 차트로 보여주어 독서 취향을 분석해줌 <br> ▪︎ (인스타그램과 비슷하게) 피드 기능을 제공해 독서 정보를 공유할 수 있음 | |

## 요구사항 정의

| 번호 | 구분 | 요구사항 명 | 상세 설명 | 우선 순위 | 비고 |
| :--: | :--: | :--: | :-- | :--: | :-- |
| **1** | 디자인 | 스플래시 | ▪︎ 앱의 데이터를 로딩하는 동안 스플래시 화면을 보여주도록 함 | `3` | |
| **2** | 기능<br>(로그인) | 인트로 | ▪︎ 최초 앱 실행 시, 인트로 화면을 띄우 <br> → 간단한 앱 소개 출력 / 닉네임, 프로필 이미지를 입력 | `3` | - Hero Animation <br> - Transition Animation |
| **3** | | 로그인<br>(SNS 회원) | ▪︎ SNS 회원의 경우 [애플] 등 소셜 수단으로 로그인할 수 있도록 함 | `2` | - 프로젝트 초기에는 LocalRealm으로 구현 <br> - 프로젝트 후기에 FlexibleSyncRealm 혹은 LocalRealm + CloudKit으로 구현 |
| **4** | 기능<br>(프로필・앱설정) | 프로필 보기・앱설정 | ▪︎ 소셜 개인 이미지를 볼 수 있도록 함 <br> ▪︎ In-App Purchase 및 구독 관리 기능을 제공하도록 함 | `3` | - Realm DB 연동을 위한 기초 정보 |
| **5** | 기능<br>(목표) | 도서 진척도 보기 | ▪︎ 목표 도서의 진척도 정보를 리스트로 한 눈에 볼 수 있도록 함 <br> → 셀(Cell)에는 도서 표지(Cover), 제목, 부제, 저자, 출판일, 진척도 정보를 간략하게 표시하도록 함 <br> → 목표 도서를 도서 분류 별로 볼 수 있도록 함 <br> ▪︎ 목표 도서의 진척도 정보를 리스트의 순서를 임의로 수정 가능하도록 함 | `1` | |
| **6** |  | 도서 진척도 상세 | ▪︎ 선택 도서의 상세 기능을 제공하고, 목표 달성 현황을 텍스트와 그래프로 한 눈에 볼 수 있도록 함 <br> → ⌜독서 완료⌟, ⌜목표 수정⌟, ⌜목표 삭제⌟ 기능을 제공하고, 완독 목표 달성일까지 D-Day, 일일 독서 현황 막대 그래프 정보를 표시하도록 함 <br> ▪︎ 한줄 글귀 수집 기능으로 인상 깊은 문장을 수집할 수 있도록 함 <br> ▪︎ 페이지 히스토리로 그래프뿐만 아니라 리스트로도 언제 얼마나 읽었는지 볼  있도로 함 | `1` | |
| **7** | 기능<br>(추가) | 목표 도서 추가 | ▪︎ 완독하고자 하는 도서 정보를 추가할 수 있도록 함(Sheet) <br> → [수동 추가]: 직접 도서 제목 등 정보를 입력해 추가 <br> → [검색 추가]: 알라딘에서 검색한 도서를 추가(ContextMenu) <br> → 완독 목표 날짜, 사용자 테마도 함께 설정함| `1` | |
| **8** | 기능<br>(수정) | 목표 도서 수정 | ▪︎ 목표 도서 정보를 수정할 수 있도록 함(Sheet) <br> → 완독 목표 날짜, 사용자 테마 수정 | `1` | |
| **9** | 기능<br>(삭제) | 목표 도서 삭제 | ▪︎ 목표 도서 정보를 삭제할 수 있도록 함 | `1` | |
| **10** | 기능<br>(검색) | 도서 검색 | ▪︎ 국내 도서를 검색하는 기능을 제공하도록 함 <br> → 도서 표지(Cover), 제목, 부제, 분류, 저자, 출판일 정보를 간략하게 표시하도록 함 | `1` | |
| **11** | | 검색 상세 | ▪︎ 검색한 도서 정보를 상세하게 보여주도록 함 <br> → 도서 표지(Cover), 제목, 부제, 분류, 저자, 출판일, 도서 설명 정보를 표시하도록 함 | `1` | |
| **12** | 기능<br>(책장) | 완독・좋아요 도서 보기 | ▪︎ 완독하거나 좋아요를 체크(Check)한 도서의 리스트를 볼 수 있도록 함(LazyVGrid) <br> → 도서 표지(Cover), 제목, 부제 정보를 간략하게 표시하도록 함 <br> → 토글 스위치(Toggle)를 통해 완독 혹은 좋아요 도서를 표시하도록 함 | `2` | |
| **13** | | 완독・좋아요 도서 상세 | ▪︎ 완독 도서의 세부 정보를 볼 수 있도록 함 <br> → 도서 표지(Cover), 제목, 부제 정보를 간략하게 표시하도록 함 <br> → 목표 달서 여부, 일일 독서 현황 막대 그리프 정보를 표시하도록 함 | `2` | |
| **14** | 기능<br>(분석) | 분석 결과 보기 | ▪︎ 지금까지 완독한 모든 도서의 분석 결과를 제공하도록 함 <br> → 읽고 있는 도서와 완독한 도서의 개수, 일일 (전체) 독서 현황 막대 그래프와 연속 독서 스트릭 정보를 표시하도록 함 <br> → 페이지 캘린더로 어느 일자나 얼마나(페이지) 읽었는지 한 눈에 볼 수 있도로 함 | `3` | |
| **15** | 디자인 | 애니메이션 | ▪︎ 각 뷰 사이의 전환에 히어로 애니메이션(Hero Animation) 효과를 적용하도록 함 | `1` | |
| **16** | 디자인 | 커스텀탭뷰 | ▪︎ 디폴트 탭뷰(TabView)가 아닌 다채로운 애니메이션이 적용된 탭뷰를 적용하도록 함 | `1` | |

---

* **각 우선 순위의 의미는 아래와 같음**
  + `1` 앱을 구성하는 데 있어 없어서는 안 될 필수 기능
  + `2` 앱을 구성하는 데 있어 지금 당장 구현하지 않아도 큰 지장이 없는 기능
  + `3` 앱을 구성하는 데 있어 추후 업데이트 시 구현해도 크게 무리가 없는 기능

## 데이터플로우 다이어그램

<img width="1798" alt="스크린샷 2023-03-18 오후 4 28 18" src="https://user-images.githubusercontent.com/21079970/226091665-dba22860-6f98-48bb-993b-080308e6a547.png">

## 데이터베이스 모델

> Realm DB에 맞추어 작성되었습니다.

### Profile 모델
| 번호 | 이름 | 타입 | 설명 | 비고 |
| :--: |:--: | :--: | :-- | :-- |
| **1** | id | ObjectID | 주요 키(Primary Key) | |
| **2** | nickName | String | 닉네임 | |
| **3** | image | String | 프로필 이미지 | - 이미지 파일 이름을 저장 |
| **4** | theme | Enum<Theme> | 메인 테마 | |

 - 단, DB에는 이미지 파일 이름을 저장합니다. 프로필 이미지 파일은 앱 고유의 Documents 폴더에 저장합니다. 이는 DB의 부하를 줄이고 속도를 빠르게 하기 위함입니다.

* 프로필 정보를 저장하는 DB 모델입니다.

---

### CompleteBook 모델
| 번호 | 이름 | 타입 | 설명 | 비고 |
| :--: |:--: | :--: | :-- | :-- |
| **1** | id | ObjectID | 주요 키(Primary Key) | |
| **2** | title | String | 도서 제목 | |
| **3** | author | String | 저자/아티스트 | |
| **4** | publisher | String | 출판사 | |
| **5** | pubDate | Date | 출판일(출시일) | |
| **6** | coverLink | String | 커버(표지) URL | |
| **7** | coverImage | Data | 커버(표지) 이미지  | |
| **8** | isbn13 | String | ISBN-13 | |
| **9** | itemPage | Int | 상품의 페이지 쪽 수 | |
| **10** | categoryName | String | 카테고리 명 | |
| **11** | link | String | 상품 링크 URL(알라딘) | |
| **12** | readingDate | List\<ReadingDate\> | readingDate 모델 타입의 List | - 포함 관계(Embedded Object) |
| **13** | collectBook | List\<CollectBook\> | collectBook 모델 타입의 List | - 포함 관계(Embedded Object) |
| **14** | startDate | Date | 생성 날짜 | |
| **15** | targetDate | Date | 목표 날짜 | | 
| **16** | userRating | Int | 사용자 평점 | |
| **17** | isCompleted | Bool | 완독 여부 | |

#### - ReadingDate 하위 모델
| 번호 | 이름 | 타입 | 설명 | 비고 |
| :--: |:--: | :--: | :-- | :-- |
| **1** | date | Date | 독서일 | - 년, 월, 일만 저장 |
| **2** | totalPagesRead | Int | 읽은 총 페이지 쪽 수 <br> (어디까지 읽었는지) | |
| **3** | numberOfPagesRead | Int | 읽은 페이지 쪽 수 | - 앱 내부에서 계산 후 저장 |

#### - CollectBook 하위 모델
| 번호 | 이름 | 타입 | 설명 | 비고 |
| :--: |:--: | :--: | :-- | :-- |
| **1** | sentence | String | 수집된 문장 | |

* 완독 목표로 설정한 도서 정보를 저장하는 DB 모델입니다.

---

### FavoriteBook 모델
| 번호 | 이름 | 타입 | 설명 | 비고 |
| :--: |:--: | :--: | :-- | :-- |
| **1** | id | ObjectID | 주요 키(Primary Key) | |
| **2** | title | String | 도서 제목 | |
| **3** | author | String | 저자/아티스트 | |
| **4** | publisher | String | 출판사 | |
| **5** | pubDate | Date | 출판일(출시일) | |
| **6** | coverLink | String | 커버(표지) URL | |
| **7** | coverImage | Data | 커버(표지) 이미지  | |
| **8** | categoryName | String | 카테고리 명 | |
| **9** | link | String | 상품 링크 URL | |
| **10** | isbn13 | String | ISBN-13 | |

* 좋아요 표시를 한 도서 정보를 저장하는 DB 모델입니다.

---

### AnalyzePageBook 모델
| 번호 | 이름 | 타입 | 설명 | 비고 |
| :--: |:--: | :--: | :-- | :-- |
| **1** | id | ObjectID | 주요 키(Primary Key) | |
| **2** | date | Date | 독서일 | - 년, 월만 저장 |
| **3** | numberOfPagesRead | Int | 읽은 페이지 쪽 수 | |

---

### AnalyzeCompleteBook 모델
| 번호 | 이름 | 타입 | 설명 | 비고 |
| :--: |:--: | :--: | :-- | :-- |
| **1** | id | ObjectID | 주요 키(Primary Key) | |
| **2** | date | Date | 독서일 | - 년, 월만 저장 |
| **3** | numberOfCompleteBook | Int | 완독한 책의 권 수 | |

* 월별 완독 현황 기록 정보를 저장하는 DB 모델입니다.

---

### AnalyzeCompleteBook 모델
| 번호 | 이름 | 타입 | 설명 | 비고 |
| :--: |:--: | :--: | :-- | :-- |
| **1** | id | ObjectID | 주요 키(Primary Key) | |
| **2** | morning | Int | 아침 시간대(6시 ~ 12시) | |
| **3** | afternoon | Int | 점심 시간대(12시 ~ 18시) | |
| **4** | evening | Int | 저녁 시간대(18시 ~ 24시) | |
| **5** | midnight | Int | 새벽 시간대(24시 ~ 6시) | |

* 시간대 별 독서 현황 정보를 저장하는 DB 모델입니다.

## 기능 명세서

> 구현 완료된 기능은 체크(✓) 표시가 되어 있습니다.

| 번호 | 구분 | 주 기능 | 상세 기능 | 구현 여부 | 비고 |
| :--: | :--: | :-- | :-- | :--: | :-- |
| **1** | 로그인 | 인트로・스플래시 | ▪︎ 스플래시 로딩 이미지 <br> ▪︎ 앱 소개 출력 / 닉네임, 프로필 이미지 입력 | | | 
|   | | SNS 로그인 | ▪︎ 애플, 네이버 등 | | - 프로젝트 초기에는 LocalRealm으로 구현 <br> - 프로젝트 후기에 FlexibleSyncRealm 혹은 LocalRealm + CloudKit으로 구현 | 
| **2** | 프로필 | 프로필 관리 | ▪︎ SNS의 프로필 이미지 보기 | | - 애플 ⌜건강⌟앱 참조 |
|   | | | ▪︎ In-App-Purchase 및 구독 관리 | | |
| **3** | 홈 | 목표 도서 보기 | ▪︎ 분류 별 보기 | | - Hero Animation |
|   | | 목표 도서 정렬 | ▪︎ 리스트 순서 설정 | | - 도서 명 오른차순/내림차순, 사용자 설정 순서 등 |
|   | | 목표 도서 상세 | ▪︎ 목표 달성 현황을 텍스트와 그래프로 보기 | | - Hero Animation |
|   | | | ▪︎ 도서 평점(추가/수정/삭제) | | - Hero Animation |
|   | | | ▪︎ 문장 수집(추가/수정/삭제) | | - Hero Animation |
| **4** | 도서 | 목표 도서 추가 | ▪︎ 목표 도서 추가(완독 목표일, 사용자 테마) <br> → [수동 추가]: 직접 도서 제목 등 정보를 입력해 추가 <br> → [검색 추가]: 알라딘에서 검색한 도서를 추가(ContextMenu) | | - 도서 검색 기능과 연계됨 |
|   |  | 목표 도서 수정 | ▪︎ 목표 도서 수정(상동) | | - Sheet View |
|   |  | 목표 도서 삭제 | ▪︎ 목표 도서 정보 삭제(상동) | | - ActionSheet |
| **6** | 검색 | 도서 검색 | ▪︎ 도서 검색(도서 명/저자 명) | | - Hero Animation |
|   | | 검색 상세 | ▪︎ 검색 도서 상세 보기 | | - Hero Animation |
| **7** | 책장 | 좋아요・완독 도서 보기 | ▪︎ 완독 혹은 좋아요 도서 보기 <br> → 토글 스위치(Toggle)를 통해 완독 혹은 좋아요 도서 목록 중 하나를 표시하도록 함 | | - LazyVGrid |
|   | | 좋아요・완독 도서 상세 | ▪︎ 완독 혹은 좋아요 도서 상세 정보 보기 | | - Hero Animation |
| **8** | 분석 | 분석 결과 보기 | ▪︎ 총 완독 도서 분서 결과 보기 <br> → 읽고 있는 도서와 완독한 도서의 개수, 일일 (전체) 독서 현황 막대 그래프와 연속 독서 스트릭 정보를 표시하도록 함 | | - Charts |
|   | | | ▪︎ 페이지 캘린더 보기 | | |
| **9** | 디자인 | 커스텀 탭뷰 | ▪︎ 커스텀 탭뷰 적용 | | |

## 참고 자료

| 번호 | 참고 앱 | 비고 |
| :--: | :--: | :-- |
| **1** | <img src="https://user-images.githubusercontent.com/21079970/225893316-ba084fe4-476a-4836-8fd4-43a8bdf4deaf.png" align="center" width="150" height="150"> | |
| **2** | <img src="https://user-images.githubusercontent.com/21079970/226530275-b53ae16a-337d-496e-9779-6fb09795cb0b.png" align="center" width="150" height="150"> | |

| 번호 | 참고 서적 | 비고 |
| :--: | :--: | :-- |
| **1** | [SwiftUI for Masterminds 3rd Edition 2022](https://product.kyobobook.co.kr/detail/S000061917457) | |

| 번호 | 참고 사이트 | 비고 |
| :--: | :--: | :-- |
| **1** | [Human Interface Guideline](https://developer.apple.com/design/human-interface-guidelines/guidelines/overview/) | |
| **2** | [Realm Swift SDK](https://www.mongodb.com/docs/realm/sdk/swift/) | |

<br>

---

<br>

# Commit 가이드라인

> 일관성있는 작업 기록을 남기기 위하여 아래와 같은 규칙을 지킵니다.

* 제목은 최대 50자 내로 입력합니다.
* 본문은 한 줄 최대 72자 입력합니다.

## 메세지 규칙

* `[feat]`: 새로운 기능 구현하는 경우
* `[add]`: feat 이외의 부수적인 코드 및 라이브러리가 추가된 경우 
* `[chore]`: 코드 및 내부 파일을 수정하는 경우
* `[file]`: 새로운 파일이 생성 및 삭제된 경우
* `[fix]`: 버그 및 오류를 해결한 경우 
* `[del]`: 쓸모없는 코드 및 파일을 삭제한 경우 
* `[move]`: 프로젝트 내 파일이나 코드를 이동한 경우
* `[rename]`: 파일 이름을 변경한 경우 
* `[refactor]`: 코드를 리팩토링한 경우
* `[docs]`: README 등 문서를 개정한 경우 
* `[merge]`: 다른 브렌치와 merge를 한 경우


