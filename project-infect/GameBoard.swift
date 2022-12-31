//
//  GameBoard.swift
//  project-infect
//
//  Created by Jerald Stephenson on 12/31/22.
//

import SwiftUI

class GameBoard: ObservableObject {
    let rowCount = 11
    let columnCount = 22
    
    @Published var grid = [[ZombieVirus]]()
    
    init() {
        reset()
    }
    
    func reset() {
        grid.removeAll()
        
        for row in 0..<rowCount {
            var newRow = [ZombieVirus]()
            
            for col in 0..<columnCount {
                let zombieVirus = ZombieVirus(row: row, col: col)
                newRow.append(zombieVirus)
            }
            
            grid.append(newRow)
        }
        
        grid[0][0].color = .green
        grid[rowCount - 1][columnCount - 1].color = .red
        
        
    }
}
