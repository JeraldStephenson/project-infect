//
//  ContentView.swift
//  project-infect
//
//  Created by Jerald Stephenson on 12/23/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var board = GameBoard()
    var body: some View {
        //this outer v stack will handle our scores plus our inner-vstack(gameboard)
        VStack {
            HStack {
                Text("GREEN: \(board.greenScore)")
                    .padding(.horizontal)
                    .background(Capsule().fill(.green).opacity(board.currentPlayer == .green ? 1 : 0))
                
                Spacer()
                
                Text("Zombination")
                
                Spacer()
                
                Text("RED: \(board.redScore)")
                    .padding(.horizontal)
                    .background(Capsule().fill(.red).opacity(board.currentPlayer == .red ? 1 : 0))
            }
            .font(.system(size: 36).weight(.black))
           
            //a Z stack that wraps our game board and our winner screen/view
            ZStack {
                
                
                //our game board view
                VStack{
                    ForEach(0..<11, id: \.self) { row in
                        HStack {
                            ForEach(0..<22, id: \.self) { col in
                                let zombieVirus = board.grid[row][col]
                                
                                
                                ZombieVirusView(zombieVirus: zombieVirus) {
                                    //rotate this zombieVirus
                                    board.rotate(zombieVirus: zombieVirus)
                                }
                            }
                        }
                    }
                }
                
                //our winner view
                if let winner = board.winner {
                    VStack {
                        Text("\(winner) wins!")
                            .font(.largeTitle)
                        
                        Button(action: board.reset) {
                            Text("Play Again")
                                .padding()
                                .background(.blue)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(40)
                    .background(.black.opacity(0.85))
                    .cornerRadius(25)
                    .transition(.scale)
                    
                }
            }
        }
        .padding()
        .fixedSize()
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
