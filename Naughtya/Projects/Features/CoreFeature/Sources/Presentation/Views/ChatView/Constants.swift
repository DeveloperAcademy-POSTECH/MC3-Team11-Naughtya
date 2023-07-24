//
//  Constants.swift
//  gtptest1
//
//  Created by DongHyeok Kim on 2023/07/19.
//

import Foundation

enum Constants {
    static let openAIAPIKey = "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"
}

let prompt: String = """
달성한 TODO에 관련된 INPUT들이 들어오면

INPUT

- [Petch] 노션 포트폴리오 `Notion`
- [Kakao Navi renewer] 노션 포트폴리오 `Notion`
- [Youtube UT] 노션 포트폴리오 `Notion`
- [뱅코 3D 모델링] 노션 포트폴리오 `Notion`

달성한 투두를 기반으로 내가 얻은 능력이나 성과를
이런식의

OUTPUT
포트폴리오 작성 능력 개선:

- [Petch] 노션 포트폴리오 작성
- [Kakao Navi renewer] 노션 포트폴리오 작성
- [Youtube UT] 노션 포트폴리오 작성

기획과 디자인 역량 강화:

- [뱅코 3D 모델링] 프로젝트를 통한 3D 모델링 작업 경험

으로 알려준다.
"""
