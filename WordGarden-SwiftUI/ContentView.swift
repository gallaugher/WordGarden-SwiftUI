//
//  ContentView.swift
//  WordGarden-SwiftUI
//  Created by John Gallaugher on 8/23/22
//  YouTube: YouTube.com/profgallaugher, Twitter: @gallaugher

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var durationValue = 5.0
    @State private var flowerImage = "flower8"
    @State private var imageName = "flower8"
    @State private var imagePrefix = "flower"
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var wordsRemaining = 0
    @State private var wordsInGame = 0
    @State private var guessedLetter = ""
    @State private var lettersGuessedCount = 0
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var wordBeingRevealed = ""
    @State private var lettersGuessed = ""
//    @State private var gameStatusMessage = "You've Made Zero Guesses"
    @State private var gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
    @State private var textFieldIsDisabled = false
    @State private var gameOver = false
    @State private var playAgainButtonLabel = "Another Word?"
    
    var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    let maxNumberOfWrongGuesses = 8
    @State private var wrongGuessesRemaining = 8
    @State private var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    VStack (alignment: .leading){
                        Text("Words Guessed: \(wordsGuessed)")
                        Text("Words Missed: \(wordsMissed)")
                    }
                    Spacer()
                    VStack (alignment: .trailing){
                        Text("Words to Guess: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                        Text("Words in Game: \(wordsToGuess.count)")
                    }
                }
                .padding(.horizontal)
                .font(.caption)
            }
            
            Spacer()
            
            Group {
//                Text("How Many Guesses to Uncover the Hidden Word?")
                Text(gameStatusMessage)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .frame(height: 80)
                    .minimumScaleFactor(0.50)
                    .padding()
                
                Spacer()
                
                Text(wordBeingRevealed)
                
                Spacer()
                
                HStack{
                    if playAgainHidden {
                        TextField("", text: $guessedLetter)
                            .textFieldStyle(.roundedBorder)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.gray, lineWidth: 2)
                            )
                            .disableAutocorrection(true)
                            .frame(width: 30)
                            .textInputAutocapitalization(.characters)
                            .submitLabel(.done)
                            .keyboardType(.asciiCapable)
                            .onChange(of: guessedLetter, perform: { _ in
                                guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                                guard let lastLetter = guessedLetter.last else {
                                    return
                                }
                                guessedLetter = String(lastLetter.uppercased())
                            })
                            .onSubmit {
                                guard guessedLetter != "" else {
                                    return
                                }
                                guessALetter()
                                updateUIAfterGuess()
                            }
                            .focused($textFieldIsFocused)
                        
                        
                        Button("Guess a Letter") {
                            guard guessedLetter != "" else {
                                return
                            }
                            guessALetter()
                            textFieldIsFocused = false
                            updateUIAfterGuess()
                        }
                        .buttonStyle(.bordered)
                        .tint(.mint)
                        .disabled(guessedLetter.isEmpty || gameOver)
                    }
                }
                
                if !playAgainHidden {
                    Button(playAgainButtonLabel) {
                        if currentWordIndex == wordsToGuess.count {
                            currentWordIndex = 0
                            wordsGuessed = 0
                            wordsMissed = 0
                        }
                        imageName = "flower8"
                        playAgainHidden = true
                        textFieldIsDisabled = false
                        gameOver = false
                        wordToGuess = wordsToGuess[currentWordIndex]
                        wrongGuessesRemaining = maxNumberOfWrongGuesses
                        wordBeingRevealed = "_" + String(repeating: " _", count: wordToGuess.count-1)
                        lettersGuessedCount = 0
                        lettersGuessed = ""
                        gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
                        playAgainButtonLabel = "Another Word?"
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)
                }
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .animation(.easeIn(duration: 0.75), value: imageName)
            
            
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear() {
            wordToGuess = wordsToGuess[currentWordIndex]
            wordBeingRevealed = "_" + String(repeating: " _", count: wordToGuess.count-1)
        }
    }
    
    func updateUIAfterGuess() {
        guessedLetter = ""
    }
    
    func formatRevealedWord() {
        var revealedWord = ""
        for letter in wordToGuess {
            if lettersGuessed.contains(letter) {
                revealedWord = revealedWord + "\(letter) "
            } else {
                revealedWord = revealedWord + "_ "
            }
        }
        revealedWord.removeLast()
        wordBeingRevealed = revealedWord
    }
    
    func guessALetter() {
        lettersGuessed = lettersGuessed + guessedLetter
        formatRevealedWord()
        
        // Update flowers if wrong guess
        if !wordToGuess.contains(guessedLetter) {
            wrongGuessesRemaining -= 1
            durationValue = 5.0
            imageName = "wilt\(wrongGuessesRemaining)"
            print("durationValue = \(durationValue), imageName = \(imageName)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                imageName = "flower\(wrongGuessesRemaining)"
                durationValue = 0.01
            }
            playSound(soundName: "incorrect")
        } else {
            playSound(soundName: "correct")
        }
        
        // Update game status labels
        lettersGuessedCount += 1
        gameStatusMessage = "You've Made \(lettersGuessedCount) Guess\(lettersGuessedCount == 1 ? "" : "es")"
        
        if !wordBeingRevealed.contains("_") {
            gameStatusMessage = "You've Guessed It! It Took You \(lettersGuessedCount) Guesses to Guess the Word."
            wordsGuessed += 1
            playSound(soundName: "word-guessed")
            updateAfterWinOrLose()
        } else if wrongGuessesRemaining == 0 {
            gameStatusMessage = "So Sorry. You're All Out of Guesses."
            wordsMissed += 1
            playSound(soundName: "word-not-guessed")
            updateAfterWinOrLose()
        }
        
        if currentWordIndex == wordsToGuess.count {
            playAgainButtonLabel = "Restart Game?"
            gameStatusMessage = gameStatusMessage + "\nYou've Tried All of the Words. Restart from the Beginning?"
        }
    }
    
    func updateAfterWinOrLose() {
        currentWordIndex += 1
        textFieldIsDisabled = true
        gameOver = false
        playAgainHidden = false
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
