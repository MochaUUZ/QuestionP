//
//  ContentView.swift
//  Shared
//
//  Created by Sheng hao Dong on 5/6/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    QuestionPage(quizManagerVM: QuizManagerVM())
                } label: {
                    Text("Begin Mock Exam")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
                // End of navigation link
            }
            // end of VStack
            .navigationTitle("Create Exam")
            .padding()
            .background(Color.EQALS_Green)
            .cornerRadius(10)
        }
        // End of navigation view
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
