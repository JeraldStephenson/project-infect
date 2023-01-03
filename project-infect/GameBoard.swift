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
                //creating our ZombieVirus node for current row and current column
                let zombieVirus = ZombieVirus(row: row, col: col)
                
                //logic to randomize half the board and mirror so that it is fair (fully randomized creates unfair opportunity during play)
                if row <= rowCount / 2 {
                    if row == 0 && col == 0 {
                        //make sure the player starts pointing away from anything
                        zombieVirus.direction = .north
                    } else if row == 0 && col == 1 {
                        //make sure nothing points to the player
                        zombieVirus.direction = .east
                    } else if row == 1 && col == 0 {
                        //make sure nothing points to the player
                        zombieVirus.direction = .south
                    } else {
                        //all other pieces are random
                        zombieVirus.direction = ZombieVirus.Direction.allCases.randomElement()!
                    }
                } else {
                    //mirror the top half of board (randomized) to the bottom half so that it is inverted and equal for player 2
                    if let counterpart = getZombieVirus(atRow: rowCount - 1 - row, col: columnCount - 1 - col) {
                        zombieVirus.direction = counterpart.direction.opposite
                    }
                }
                
                newRow.append(zombieVirus)
            }
            
            grid.append(newRow)
        }
        //setting the player starting points
        grid[0][0].color = .green
        grid[rowCount - 1][columnCount - 1].color = .red
    }
    
    
    func getZombieVirus(atRow row: Int, col: Int) -> ZombieVirus? {
        guard row >= 0 else {return nil}
        guard row < grid.count else { return nil }
        guard col >= 0 else { return nil }
        guard col < grid[0].count else {return nil}
        return grid[row][col]
    }
    
    
    func infect(from: ZombieVirus) {
        //more code to come
        objectWillChange.send()
        
        var peopleToInfect = [ZombieVirus?]()
        
        switch from.direction {
            //if current is pointing north, read the peopleToInfect right above current
        case .north:
            peopleToInfect.append(getZombieVirus(atRow: from.row - 1, col: from.col))
            //if current is pointing south, read the peopleToInfect right below current
        case .south:
            peopleToInfect.append(getZombieVirus(atRow: from.row + 1, col: from.col))
            //if current is pointing east, read the peopleToInfect to the right of current
        case .east:
            peopleToInfect.append(getZombieVirus(atRow: from.row, col: from.col + 1))
            //if current is pointing west, read the peopleToInfect to the left of current
        case .west:
            peopleToInfect.append(getZombieVirus(atRow: from.row, col: from.col - 1))
        }
        
        //if our ZombieVirus optional unwraps into a value, loop through people to infect
        for case let zombieVirus? in peopleToInfect {
            //if current zombieVirus within peopleToInfect array has different color than the color of zombieVirus we passed in as argument to infect (note the *from* argument label), change color to that color (from the *from* argument label)
            if zombieVirus.color != from.color {
                zombieVirus.color = from.color
                //recursive call of infect on current zombieVirus node in our loop
                infect(from: zombieVirus)
            }
        }
    }
    
    func rotate(zombieVirus: ZombieVirus) {
        objectWillChange.send()
        
        zombieVirus.direction = zombieVirus.direction.next
        
        infect(from: zombieVirus)
    }
}
