//
//  ScoreLabels.swift
//  swiftui_rock-paper-scissors
//
//  Created by Joonas Junttila on 17/06/2019.
//  Copyright © 2019 Joonas Junttila. All rights reserved.
//

import SwiftUI

struct ScoreLabels : View {
    
    var player1, player2, score1, score2: String
    var showTurnLabel: Bool
    var turn: Player
    
    var body : some View {
        
        HStack {
            
            VStack {
                Text(player1)
                Text(score1)
                    .font(.title)
            }
            
            Spacer()
            
            if showTurnLabel {
                VStack {
                    Text("Turn")
                    Text(turn == .player1 ? player1 : player2)
                        .font(.title)
                }
                
                Spacer()
            }
            
            VStack {
                Text(player2)
                Text(score2)
                    .font(.title)
            }
            
            }
            .padding()
    }
}
