//
//  ContentView.swift
//  swiftui_rock-paper-scissors
//
//  Created by Joonas Junttila on 16/06/2019.
//  Copyright © 2019 Joonas Junttila. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    @ObservedObject var game = GameEngine()
    
    @State private var player2UsingAI = true
    @State private var aiDifficulty = 5
    @State private var showRestartConfirmation = false
    
    var body: some View {
        
        let player1Name: String = player2UsingAI ? "You" : "Player 1"
        let player2Name: String = player2UsingAI ? "Computer" : "Player 2"
        
        var streakExists: Bool {
            return game.state.player1Streak > 0 || game.state.player2Streak > 0
        }
        	
        return NavigationView {
            
            Group {
                ScoreLabels(player1: player1Name,
                            player2: player2Name,
                            score1: String(game.state.player1Score),
                            score2: String(game.state.player2Score),
                            showTurnLabel: !player2UsingAI,
                            turn: game.state.turn)
                
                HStack {
                    ForEach (RockPaperScissors.allCases, id: \.self) { option in
                        Button(action: {
                            self.playTurn(with: option)
                        }) {
                            Text(option.rawValue.uppercased())
                                .font(.system(size: 20))
                                .bold()
                                .padding()
                                .background(Color(white: 0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        self.game.startOver()
                    }) {
                        Text("Restart Game")
                    }
                }
                
                HStack {
                    Text("History:").font(.title)
                    Spacer()
                    if streakExists {
                        VStack(alignment: .trailing) {
                            Text("Streak").font(.headline)
                            Text(game.state.player1Streak > 1 ? String(game.state.player1Streak) : String(game.state.player2Streak))
                        }
                    }
                }
                .padding(.horizontal)
                
                PreviousMovesList(moves: game.state.moves,
                                  player1: player1Name,
                                  player2: player2Name)
            }
            .navigationBarTitle(Text("RockPaperScissors"))
            .navigationBarItems(
                    leading: Toggle(isOn: $player2UsingAI) { Text("Use AI") },
                    trailing: Group {
                        if player2UsingAI {
                            Stepper(value: $aiDifficulty, in: 1...10, label: {
                                Text("Difficulty: \(aiDifficulty)")
                            })
                        }
                    }
            )
            
            
        }
    }
    
    func playTurn(with selectedOption: RockPaperScissors) {
        
        if player2UsingAI {
            
            game.player1Move = selectedOption
            game.player2Move = GameAI().playTurnWithAI(previousTurns: game.state.moves, difficulty: aiDifficulty)
            
        } else {
            
            switch game.turn {
            case .player1:
                game.player1Move = selectedOption
            case .player2:
                game.player2Move = selectedOption
            }
        }
        
        _ = game.playTurn()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
