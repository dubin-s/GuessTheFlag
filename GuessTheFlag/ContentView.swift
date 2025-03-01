//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Spenser Dubin on 2/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var score = 0
    @State private var scoreTitle = ""
    @State private var questionsAsked = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(hue: 0.51, saturation: 0.20, brightness: 0.36), location: 0.3),
                .init(color: Color(hue: 0.13, saturation: 0.53, brightness: 0.81), location: 0.3),
            ], center: .bottom, startRadius: 50, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.rect(cornerRadius: 8))
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 13))
                
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert(scoreTitle, isPresented: $gameOver) {
            Button("Reset Game", action: resetGame)
        } message: {
            Text("Your score is \(score). Reset the game to try again!")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        if questionsAsked == 7 {
            gameOver = true;
            if score > 5 {
                scoreTitle = "Great job!"
            } else {
                scoreTitle = "Game over!"
            }
            return
        }
        questionsAsked += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        scoreTitle = ""
        score = 0
        questionsAsked = 0
        gameOver = false
        showingScore = false
        askQuestion()
    }
}

#Preview {
    ContentView()
}
