//
//  GameAI.swift
//  swiftui_rock-paper-scissors
//
//  Created by Joonas Junttila on 21/06/2019.
//  Copyright © 2019 Joonas Junttila. All rights reserved.
//

import Foundation

class GameAI {
    
    func playTurnWithAI(previousTurns: [Turn], difficulty: Int) -> RockPaperScissors {
        
        switch difficulty {
            
        // aina paperi
        case 1:
            return .paper
        
        // vuorotellen kaikkia
        case 2:
            let remainder:Int = previousTurns.count % 3
            switch remainder {
            case 0:
                return .rock
            case 1:
                return .paper
            case 2:
                return .scissors
            default:
                fatalError()
            }
            
        // eniten voittanut siirto pelihistoriassa
        case 3:
            let turnsWithoutDraws: [Turn] = previousTurns.filter { $0.winner != nil }
            let winningMoves: [RockPaperScissors] = turnsWithoutDraws.map { turn in
                guard let winner = turn.winner  else {
                    fatalError()
                }
                
                if winner == .player1 {
                    return turn.player1Move
                } else if winner == .player2 {
                    return turn.player2Move
                } else {
                    fatalError()
                }
            }
            
            guard let mode = winningMoves.mode else { return playRandomTurn() }
            return mode
        default:
            return playRandomTurn()
        }
    }
    
    func playRandomTurn() -> RockPaperScissors {
        RockPaperScissors.allCases.randomElement() ?? .rock
    }
}

extension Array where Element: Hashable {
    var mode: Element? {
        return self.reduce([Element: Int]()) {
            var counts = $0
            counts[$1] = ($0[$1] ?? 0) + 1
            return counts
            }.max { $0.1 < $1.1 }?.0
    }
}

struct User {
    var name: String
    var age: Int
}
