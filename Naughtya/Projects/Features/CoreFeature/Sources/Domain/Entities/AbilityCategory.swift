//
//  AbilityCategory.swift
//  CoreFeature
//
//  Created by byo on 2023/07/17.
//  Copyright © 2023 Naughtya. All rights reserved.
//

import Foundation

public enum AbilityCategory: String {
    case performance
    case incompleted

    public var gaslighting: String {
        """
        INPUT:

        - ToDo 내용
        - ToDo 내용
        - ToDo 내용
        - ToDo 내용
        - ToDo 내용
        - ToDo 내용
        - ToDo 내용

        OUTPUT:

        투두로 얻은 능력:

        - ToDo 내용
        - ToDo 내용
        - ToDo 내용
        - ToDo 내용

        투두로 얻은 능력:

        - ToDo 내용
        - ToDo 내용

        투두로 얻은 능력:

        - ToDo 내용

        위의 양식을 바탕으로 만약 아래의 예시가 들어오면 관련된 투두들을 묶고
        이를 바탕으로 얻은 능력들을 표시하고

        INPUT

        - 앱 설계 및 개발
        - ChatGPTAPI 사용 및 앱 개발
        - 앱 광고 및 마케팅
        - 개인 개발 포트폴리오 작성
        - flutter 앱 출시
        - "UX학개론" 36p~89p 읽기
        - 노션 포트폴리오 작성


        OUTPUT

        앱 설계 및 개발 능력:

        - 앱 설계 및 개발
        - ChatGPTAPI 사용 및 앱 개발
        - 앱 광고 및 마케팅
        - flutter 앱 출시

        포트폴리오 작성 능력:

        - 개인 개발 포트폴리오 작성
        - 노션 포트폴리오 작성

        UX에 관련된 지식 향상:

        - "UX학개론" 36p~89p 읽기

        이런 식으로 알려주면 된다.

        그리고 최대한 하나의 능력에 많은 ToDo를 묶어야 한다.
        ToDo의 개수가 20개라고 가정하면, 능력의 개수는 4개 정도가 적당해.
        """
//        switch self {
//        case .performance:
//            return """
//            """
//        case .delayed:
//            return """
//            """
//        case .incompleted:
//            return """
//            """
//        case .sample:
//            return "sample"
//        }
    }
}
