//
//  QuestionPage.swift
//  QuestionWindows
//
//  Created by Sheng hao Dong on 5/6/22.
//

import SwiftUI
import AVKit

struct QuestionPage: View {
    @State var player = AVPlayer()
    
    @ObservedObject var quizManagerVM: QuizManagerVM
    @State private var showingPopover = false
    @State private var showingSubmitting = false
    @State private var testComplete = false
    
    var body: some View {
        //NavigationView {
            ScrollView {
                if(testComplete) {
                    // Test is finished, the result page
                    ExamResult(quizManagerVM: QuizManagerVM(), progressValue: quizManagerVM.returnPercentCorrect(), maxQuestion: quizManagerVM.returnMaxQuestion(), correctAnswer: quizManagerVM.returnTotalCorrectness(), questionArray: quizManagerVM.returnAnswerArray())
                } else {
                    // Test is undertaking, the question page
                    
                    // The 'Question Box' view
                    TabView {
                        ScrollView {
                            Text(quizManagerVM.model.quizinfo.question)
                                .font(.system(size: 30, weight: .semibold))
                                .padding()
                        }
                        .tag(1)
                        
                        ScrollView {
                            Text(quizManagerVM.model.quizinfo.questionSupple)
                                .font(.system(size: 25))
                                .padding()
                        }
                        .tag(2)
                        
                        ScrollView {
                            AsyncImage(url: URL(string: quizManagerVM.model.quizinfo.questionPic )) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Text("Loading...")
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 30, height: 400)
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                    .background(Color.EQALS_Ash)
                    .border(Color.white, width: 2)
                    
                    // End of 'Question Box' view
                    
                    // Answer choice view
                    if(quizManagerVM.returnAnswerType() == "Response") {
                        TextField("Input", text: $quizManagerVM.userInput, prompt: Text("Enter value"))
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .scaledToFit()
                    } else {
                        OptionGridView(quizManagerVM: quizManagerVM)
                    }
                    // End of answer choice view
                    
                    // Navigation Button View
                    HStack {
                        // Back button
                        Button {
                            quizManagerVM.goToPrevious()
                        } label: {
                            Image(systemName: "arrow.left.square")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.EQALS_Blue)
                        }
                        
                        // Check button
                        Button {
                            showingPopover = true
                        } label: {
                            Image(systemName: "checkmark.square")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.EQALS_Blue)
                        }
                        
                        // Next button
                        Button {
                            if(quizManagerVM.determineEndOfTest()) {
                                _ = quizManagerVM.returnCorrectness()
                                showingSubmitting = true
                            } else {
                                quizManagerVM.goToNext()
                            }
                        } label: {
                            Image(systemName: "arrow.right.square")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.EQALS_Blue)
                        }
                    }
                    // End of navigation button view
                }
                // End of test is undertaking, question page
            }
            .navigationTitle(quizManagerVM.returnPageTitle())
                .navigationBarTitleDisplayMode(.inline)
            // End of scroll view
            .popover(isPresented: $showingPopover) {
                ScrollView {
                    Text("Answer Status:")
                        .font(.system(size: 20))
                        .padding()
                    // Correct answer view
                    if(quizManagerVM.returnCorrectness()) {
                        Text("Correct\n").foregroundColor(Color.EQALS_Green)
                            .font(.system(size: 20))
                    } else {
                        // Incorrect answer view
                        Text("Incorrect\n").foregroundColor(Color.EQALS_Red)
                            .font(.system(size: 20))
                    }
                    Text("Explanation:")
                        .font(.system(size: 20))
                    Text(quizManagerVM.model.quizinfo.explanation).padding(.horizontal)
                    Text("\n")
                    if(quizManagerVM.model.quizinfo.explanationSupple[0].VideoUrl == "") {
                        // Do nothing
                    }
                    else {
                        VideoPlayer(player: player)
                            .onAppear() {
                                player = AVPlayer(url: URL(string: quizManagerVM.model.quizinfo.explanationSupple[0].VideoUrl!)!)
                            }
                            .scaledToFit()
                            .padding()
                    }
                    
                    if(quizManagerVM.model.quizinfo.explanationSupple[0].PicUrl == "") {
                        // Do nothing
                    } else {
                        AsyncImage(url: URL(string: quizManagerVM.model.quizinfo.explanationSupple[0].PicUrl!)!) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Text("Loading...")
                        }
                    }
                    Text(quizManagerVM.model.quizinfo.explanationSupple[0].text ?? "").padding()
                }
            }.padding()
            // End of popover view
            .alert("Submitting Test?", isPresented: $showingSubmitting) {
                Button("Yes") {
                    quizManagerVM.resetIndex()
                    testComplete = true }
                Button("No", role: .cancel) { }
            }
            // End of alert view
        }
            
        // End of navigation view
    }
    // End of body view
// end of struct

struct QuestionPage_Previews: PreviewProvider {
    static var previews: some View {
        QuestionPage(quizManagerVM: QuizManagerVM())
    }
}
