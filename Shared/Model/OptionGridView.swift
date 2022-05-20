//
//  OptionsGridView.swift
//  Capstone_EQuALS
//
//  Created by Sheng hao Dong on 4/29/22.
//

import Foundation
import SwiftUI

struct OptionGridView: View {
    var quizManagerVM: QuizManagerVM
    
    var column: [GridItem] = Array(repeating:
        GridItem(.fixed(UIScreen.main.bounds.width - 30), spacing: 0), count: 1)
    
    var body: some View {
        LazyVGrid(columns: column, spacing: 10) {
            ForEach(quizManagerVM.model.quizinfo.answerChoice) { quizOption in
                OptionCardView(answerOption: quizOption)
                    .onTapGesture {
                        quizManagerVM.verifyAnswer(selectedOption: quizOption)
                    }
            }
        }
    }
}

struct OptionCardView: View {
    var answerOption: AnswerChoice
    
    var body: some View {
        VStack {
            if(answerOption.isMatched) && (answerOption.isSelected) {
                OptionView(answerOption: answerOption)
            } else if (!(answerOption.isMatched) && (answerOption.isSelected)) {
                OptionView(answerOption: answerOption)
            } else {
                OptionView(answerOption: answerOption)
            }
        }.background(setBackgroundColor())
            .cornerRadius(20)
    }
    
    func setBackgroundColor() -> Color {
        if answerOption.isSelected {
            return Color.EQALS_Ash
        } else {
            return Color(UIColor.systemBackground)
        }
    }
}

struct OptionView: View {
    var answerOption: AnswerChoice
    
    var body: some View {
        HStack {
            Text("\(answerOption.type). \(answerOption.choice)")
                .font(.system(size: 25, weight: .semibold))
            Spacer()
        }
        .padding(10)
        .cornerRadius(10)
    }
}
