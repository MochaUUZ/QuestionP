//
//  ExamResult.swift
//  QuestionWindows
//
//  Created by Sheng hao Dong on 5/7/22.
//

import SwiftUI

struct ExamResult: View {
    @ObservedObject var quizManagerVM: QuizManagerVM
    @State var progressValue: Float = 0.0
    @State var maxQuestion: Int = 0
    @State var correctAnswer: Int = 0
    @State var questionArray: [Int]
    
    var body: some View {
        // The background
        ZStack {
            // The collection of containers
            VStack {
            // The exam info container{
                HStack {
                    // the date of completion
                    VStack(spacing: 0) {
                        Text("March 24")
                            .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 16)
                            .background(Color.EQALS_Gray)
                            .cornerRadius(20, corners: [.topLeft, .topRight])
                        Text("4:37 PM")
                            .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 16)
                            .background(Color.Light_White)
                            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    }
                    // Exam Detail
                    VStack {
                        // Exam Title
                        Text("Prepare Sample Question")
                            .font(.system(size: 20, weight: .semibold))
                        HStack{
                            // Time duration
                            Text("")
                            
                            // Total Question
                            Text("10 Questions")
                        }
                        Divider().background(Color.black)
                    }
                }.padding()
                .frame(width: UIScreen.main.bounds.width - 30)
                .background(Color.white)
                .cornerRadius(30)
                // End of Exam info container
                
                // The exam overview container
                VStack {
                    // The exam grade container
                    HStack(alignment: .center) {
                        ProgressBar(progress: self.$progressValue)
                        // Show amount of correct vs incorrect answer
                        VStack(alignment: .leading) {
                            // Show amount of correct
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.blue)
                                Text("Correct (\(correctAnswer)/\(maxQuestion))")
                                    .font(.title3)
                            }.padding(.bottom, 15)
                            
                            // Show amount of incorrect
                            HStack {
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.EQALS_Red)
                                Text("Incorrect (\(maxQuestion - correctAnswer)/\(maxQuestion))")
                                    .font(.title3)
                            }
                        }.padding()
                        // End of correct vs incorrect container
                    }.padding()
                    // end of exam grade container
                    
                    Divider().background(Color.black).padding()
                    
                    // The list of question container
                    HStack {
                        // The question list
                        List {
                            // First row of question list
                            HStack(alignment: .center, spacing: nil) {
                                Text("#").padding(3)
                                    .frame(maxWidth: 20, alignment: .leading)
                                Divider()
                                
                                Text("Choice")
                                    .frame(maxWidth: 60, alignment: .leading)
                                Divider()
                                Text("Question").padding(3)
                                    .frame(maxWidth: 190, alignment: .leading)
                                Divider()
                                Text("status").padding(3)
                                    .frame(alignment: .leading)
                            }.listRowBackground(Color.Light_blue)
                            // End of first row
                            
                            ForEach(0..<maxQuestion, id: \.self) {number in
                                HStack(alignment: .center, spacing: nil) {
                                    Text("\(number)").padding(3)
                                        .frame(maxWidth: 20, alignment: .leading)
                                    Divider()
                                    
                                    Text(quizManagerVM.returnPlayerChoice()[number])
                                        .frame(maxWidth: 60, alignment: .leading)
                                    Divider()
                                    Text(quizManagerVM.returnQuestion(i: number)).padding(3)
                                        .frame(maxWidth: 190, alignment: .leading)
                                    Divider()
                                    quizManagerVM.returnStatucPic(i: number)
                                        .frame(alignment: .leading)
                                }
                                
                            }
                        }
                        // end of question list
                    }.scaledToFit()
                    // End of list of question container
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(Color.white)
                // End of exam overview container
                
                Spacer()
                
            }.padding()
            // End of collection of containers
        }.background(Color.EQALS_Ash)
            .ignoresSafeArea()
        // End of the background view
    }
    // End of body view
}
// End of struct

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 15)
                .opacity(0.5)
                .foregroundColor(Color.EQALS_Red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
            Text(String(format: "%.0f %%", min(self.progress, 1.0) * 100.0))
                .font(.largeTitle)
                .bold()
            
        }.frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 6)
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct ExamResult_Previews: PreviewProvider {
    static var previews: some View {
        ExamResult(quizManagerVM: QuizManagerVM(), progressValue: 0.2, maxQuestion: 2, correctAnswer: 1, questionArray: [1, 2])
    }
}
