//
//  JSONManager.swift
//  Capstone_EQuALS
//
//  Created by Sheng hao Dong on 4/29/22.
//

import Foundation

struct question {
    var currenctQuestionIndex: Int
    var quizinfo: questionInfo
    var quizCompleted: Bool = false
}

struct questionInfo: Codable {
    let question, questionSupple, choiceType, answer, questionPic: String
    var answerChoice: [AnswerChoice]
    let explanation: String
    let explanationSupple: [ExplanationSupple]
    
    static let allQuestion: [questionInfo] = Bundle.main.decode(file: "structual_Q.json")
}

// MARK: - AnswerChoice
struct AnswerChoice: Codable, Identifiable {
    var id: Int
    let type, choice: String
    var isSelected, isMatched, isPicked: Bool
}

// MARK: - ExplanationSupple
struct ExplanationSupple: Codable {
    let VideoUrl, text, PicUrl: String?
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}
