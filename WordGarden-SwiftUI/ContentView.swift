//
//  ContentView.swift
//  WordGarden-SwiftUI
//  Created by John Gallaugher on 8/23/22
//  YouTube: YouTube.com/profgallaugher, Twitter: @gallaugher

import SwiftUI

struct ContentView: View {
    @State private var flowerImage = "flower8"
    @State private var flowerNumber = 8
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var wordsRemaining = 0
    @State private var wordsInGame = 0
    @State private var guessedLetter = ""
    @State private var playAgainHidden = true
    var body: some View {
        VStack {
            Group {
                HStack {
                    VStack (alignment: .leading){
                        Text("Words Guessed: \(wordsGuessed)")
                        Text("Words Remaining: \(wordsMissed)")
                    }
                    Spacer()
                    VStack (alignment: .trailing){
                        Text("Words Remaining: \(wordsGuessed)")
                        Text("Words in Game: \(wordsMissed)")
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Group {
                Text("How Many Guesses to Uncover the Hidden Word?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                Text("_ _ _ _ _")
                
                Spacer()
                
                HStack{
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .textInputAutocapitalization(.characters)
                    Button("Guess a Letter") {
                        // TODO: Button code
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                }
                
                if !playAgainHidden {
                    Button("Play Again?") {
                        // TODO: Play Again Code
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            Spacer()
            
            Text("You've Made Zero Guesses")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            Image("flower\(flowerNumber)")
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
