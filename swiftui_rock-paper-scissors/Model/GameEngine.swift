//
//  GameEngine.swift
//  swiftui_rock-paper-scissors
//
//  Created by Joonas Junttila on 16/06/2019.
//  Copyright © 2019 Joonas Junttila. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum RockPaperScissors: String, CaseIterable {
    case rock, paper, scissors
}

enum Player {
    case player1
    case player2
    
    mutating func toggle() {
        if self == .player1 {
            self = .player2
        } else {
            self = .player1
        }
    }
}

struct Turn: Identifiable, Hashable {
    var id: Int
    var player1Move: RockPaperScissors
    var player2Move: RockPaperScissors
    var winner: Player?
}

struct GameState {
    var turn: Player = .player1
    var player1Score: Int = 0
    var player2Score: Int = 0
    var player1Streak: Int = 0
    var player2Streak: Int = 0
    var moves: [Turn] = .init()
}

class GameEngine: ObservableObject {
    
    
    @Published var state = GameState.init()
       
    var player1Move: RockPaperScissors? = nil {
        
        didSet {
            guard turn == .player1 else {
                self.player1Move = oldValue
                return
            }
            
            turn = .player2
        }
    }
    var player2Move: RockPaperScissors? = nil {
        
        didSet {
            guard turn == .player2 else {
                self.player1Move = oldValue
                return
            }
            
            turn = .player1
        }
    }
    
    var turn: Player = .player1
    private var previousMoves: [Turn] = .init()
    
    private var player1Score: Int {
        scoreForPlayer(.player1)
    }
    
    private var player2Score: Int {
        scoreForPlayer(.player2)
    }
    
    private var player1Streak: Int {
        streakForPlayer(.player1)
    }

    private var player2Streak: Int {
        streakForPlayer(.player2)
    }

    func playTurn() -> Player? {
        
        var winner: Player?
        
        guard player1Move != nil, player2Move != nil else { return .none }
        
        if player1Move == player2Move {
            
            winner = nil
        
        } else if player2Move == .paper {
            
            winner = player1Move == .rock ? .player2 : .player1
        
        } else if player2Move == .rock {
            
            winner = player1Move == .paper ? .player1 : .player2
        
        } else if player2Move == .scissors {
            
            winner = player1Move == .rock ? .player1 : .player2
        
        } else {
            
            fatalError("Game winning logic is false")
        }
        
        let move = Turn(id: self.state.moves.count + 1, player1Move: player1Move!, player2Move: player2Move!, winner: winner)
        
        previousMoves.append(move)
        
        state = .init(
            turn: turn,
            player1Score: player1Score,
            player2Score: player2Score,
            player1Streak: player1Streak,
            player2Streak: player2Streak,
            moves: previousMoves
        )
        
        return winner
    }
    
    func startOver(){
        self.previousMoves = .init()
        state = .init()
    }
    
    private func scoreForPlayer(_ player: Player) -> Int {
        var score = 0
        
        for move in previousMoves {
            if move.winner == player { score += 1 }
        }
        
        return score
    }
    
    private func streakForPlayer(_ player: Player) -> Int {
        var streak = 1
        var previousMove: Turn? = nil
        
        for move in previousMoves {
    
            guard let previousWinner = previousMove?.winner, let winner = move.winner else {
                streak = 1
                previousMove = move
                continue
            }
            
            guard winner == player, previousWinner == player else {
                streak = 1
                previousMove = move
                continue
            }
            
            streak += 1
            previousMove = move
        }
        
        return streak
    }
    
}


