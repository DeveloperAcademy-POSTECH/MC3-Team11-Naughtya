////
////  ProjectResultCardView.swift
////  CoreFeature
////
////  Created by 김정현 on 2023/07/27.
////  Copyright © 2023 Naughtya. All rights reserved.
////
//
import SwiftUI

public struct ProjectResultCardView: View {
    
    
    
    
    public init () {
        
    }
    public var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<50, id: \.self) { num in
                    Text("\(num)")
                        .resultCardView()
                        
                }
            }
            
            
        }
    }
}

extension View {
    
    func resultCardView() -> some View {
        modifier(ProjectResultCardModifier())
    }
}

public struct ProjectResultCardView_Previews: PreviewProvider {
    public static var previews: some View {
        ProjectResultCardView()
    }
}

