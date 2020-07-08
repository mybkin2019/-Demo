//
//  questionPanelModifier.swift
//  Q&AGame
//
//  Created by billbill on 2020/7/7.
//  Copyright © 2020 billbill. All rights reserved.
//

import SwiftUI

// 这里主要是学习怎么去封装一个 ViewModifier的
struct QuestionPanelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
			.frame(width: UIScreen.main.bounds.width - 50, height: 250)
			.background(
				RoundedRectangle(cornerRadius: 15, style: .circular)
					.fill(Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)).opacity(0.5))
			)
			.shadow(radius: 20)
			.padding()
    }
}

