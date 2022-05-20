//
//  QuizManagerVM.swift
//  QuestionWindows
//
//  Created by Sheng hao Dong on 5/6/22.
//

import Foundation
import SwiftUI
import AVFoundation

class QuizManagerVM: ObservableObject {
    
    static var quizData: [questionInfo] = questionInfo.allQuestion
    static var currentIndex = 0
    static var maxQuestion = quizData.count
    // The choices that user picked
    static var playerChoice = Array(repeating: "", count: maxQuestion)
    // The correctness of each question
    static var answerStatus = Array(repeating: true, count: maxQuestion)
    
    // For testing purpose
    static var currentUserChoice = ""
    
    // For determine the test had ended
    static var testEnd = false
    
    // For storing response type question's answer
    @Published var userInput = ""
    
    static func createQuizModel(i: Int) -> question {
        let tempQ = question(currenctQuestionIndex: i, quizinfo: quizData[i])
        return tempQ
    }
    
    @Published var model = QuizManagerVM.createQuizModel(i: QuizManagerVM.currentIndex)
    
    func verifyAnswer(selectedOption: AnswerChoice) {
        if let index = model.quizinfo.answerChoice.firstIndex(where: {$0.type == selectedOption.type} ) {
            if(QuizManagerVM.currentUserChoice.count < model.quizinfo.answer.count && !QuizManagerVM.currentUserChoice.contains(selectedOption.type.first!)) {
                // The user selected choice is less than the answer choice's length, keep on adding
                model.quizinfo.answerChoice[index].isSelected = true
                QuizManagerVM.currentUserChoice = QuizManagerVM.currentUserChoice + selectedOption.type
            } else if(model.quizinfo.answerChoice[index].isSelected == true) {
                // User is trying to cancel selected answer choice
                // should de-select choice from screen, and make change to current user choice
                model.quizinfo.answerChoice[index].isSelected = false
                if let i = QuizManagerVM.currentUserChoice.firstIndex(of: selectedOption.type.first!) {
                    QuizManagerVM.currentUserChoice.remove(at: i)
                }
            } else if(model.quizinfo.answerChoice[index].isSelected == false) {
                QuizManagerVM.currentUserChoice = QuizManagerVM.currentUserChoice + selectedOption.type
                QuizManagerVM.currentUserChoice.removeFirst()
                // User is trying to add new answer choice but reached answr capacity, should de-select the 'oldest' choice and add the newest choice to the screen and the current user choice.
                for index in model.quizinfo.answerChoice.indices {
                    if(QuizManagerVM.currentUserChoice.contains(model.quizinfo.answerChoice[index].type.first!)) {
                        // The current user choice contain such choice, so reflect such info on screen
                        model.quizinfo.answerChoice[index].isSelected = true
                    }else {
                        // The current user choice does not contain such choice, so reflect such info on screen
                        model.quizinfo.answerChoice[index].isSelected = false
                    }
                }
            }
        }
        QuizManagerVM.playerChoice[returnCurrentIndex()] = QuizManagerVM.currentUserChoice
        
    }
    // end of parent if statement
    
    func goToNext() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            _ = self.returnCorrectness()
            QuizManagerVM.currentUserChoice = ""
            print(QuizManagerVM.playerChoice)
            if (QuizManagerVM.currentIndex < QuizManagerVM.maxQuestion - 1) {
                QuizManagerVM.currentIndex = QuizManagerVM.currentIndex + 1
                self.model = QuizManagerVM.createQuizModel(i: QuizManagerVM.currentIndex)
            }
        }
    }
    
    func goToPrevious() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if (QuizManagerVM.currentIndex > 0) {
                QuizManagerVM.currentIndex = QuizManagerVM.currentIndex - 1
                self.model = QuizManagerVM.createQuizModel(i: QuizManagerVM.currentIndex)
            } else {
                
            }
        }
    }
    
    func determineEndOfTest() -> Bool {
        if (QuizManagerVM.currentIndex >= QuizManagerVM.maxQuestion - 1)
        {
            return true
        }
        else {
            return false
        }
    }
    
    func returnPlayerChoice() -> [String] {
        print(QuizManagerVM.playerChoice)
        return QuizManagerVM.playerChoice
    }
    
    func returnCorrectness() -> Bool{
        // Sort the user's choice based on ascending order
        var choiceSorted = ""
        
        if(model.quizinfo.choiceType == "multiple") {
            let choiceCollection: String = QuizManagerVM.currentUserChoice
            var characters = Array(choiceCollection)
            characters = characters.sorted()
            choiceSorted = String(characters)
        } else{
            QuizManagerVM.playerChoice[returnCurrentIndex()] = userInput
            choiceSorted = userInput
        }
        
        // should return the correctness status of each questions in the form of array
        if(choiceSorted == model.quizinfo.answer){
            QuizManagerVM.answerStatus[QuizManagerVM.currentIndex] = true
        } else {
            QuizManagerVM.answerStatus[QuizManagerVM.currentIndex] = false
        }
        userInput = ""
        return QuizManagerVM.answerStatus[QuizManagerVM.currentIndex]
    }
    
    func existQuestionSupplement() -> Bool{
        if (model.quizinfo.questionSupple == "")
        {
            print("No qSupple")
            return false
        }else {
            print("Yes qSupple")
            return true
        }
    }
    
    func returnMaxQuestion() -> Int {
        return QuizManagerVM.maxQuestion
    }
    
    func returnTotalCorrectness() -> Int {
        var count = 0
        for status in QuizManagerVM.answerStatus {
            if(status == true) {
                count = count + 1
            }
        }
        return count
    }
    
    func returnCurrentIndex() -> Int {
        return QuizManagerVM.currentIndex
    }
    
    func qSupple() -> String {
        print(model.quizinfo.questionSupple)
        print(model.quizinfo.questionSupple)
        print(model.quizinfo.questionSupple)
        
        return model.quizinfo.questionSupple
    }
    
    func resetIndex() {
        QuizManagerVM.currentIndex = 0
        QuizManagerVM.testEnd = true
        model = QuizManagerVM.createQuizModel(i: QuizManagerVM.currentIndex)
    }
    
    func returnPageTitle() -> String {
        if(QuizManagerVM.testEnd) {
            QuizManagerVM.testEnd = false
            return "Exam Result"
        } else {
            return "Question \(QuizManagerVM.currentIndex)"
        }
    }
    
    func returnPercentCorrect() -> Float{
        return Float(returnTotalCorrectness()) / Float(QuizManagerVM.maxQuestion)
    }
    
    func returnAnswerArray() -> [Int] {
        var result = Array(repeating: 0, count: QuizManagerVM.maxQuestion)
        for i in 0..<QuizManagerVM.maxQuestion {
            result[i] = i + 1
        }
        
        return result
    }
    
    func returnQuestion(i: Int) -> String {
        let questionPointer = question(currenctQuestionIndex: i, quizinfo: questionInfo.allQuestion[i])
        return questionPointer.quizinfo.question
    }
    
    @ViewBuilder
    func returnStatucPic(i: Int) -> some View {
        if(QuizManagerVM.answerStatus[i] == true) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.Light_blue)
                    .scaledToFit()
        } else {
            Image(systemName: "x.circle.fill")
                .foregroundColor(Color.EQALS_Red)
                .imageScale(.medium)
        }
    }
    
    func forTest() {
        print(model.quizinfo.questionSupple == "")
    }
    
    func returnAnswerType() -> String {
        return model.quizinfo.choiceType
    }
}
