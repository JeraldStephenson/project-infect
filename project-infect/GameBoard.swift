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
    
    @Published var currentPlayer = Color.green
    @Published var greenScore = 1
    @Published var redScore = 1
        
    @Published var winner: String? = nil
    //after adding a delay to infecting zombieVirus nodes, we need to prevent switching to next player until the gameboard is done infecting all of the nodes it is suppose to - we will create a variable counter that will track amount of nodes that should be infected and decrement it as nodes are infected and once it is == 0 turn ends
    private var peopleBeingInfected = 0
    
    init() {
        reset()
    }
    
    func reset() {
        winner = nil
        currentPlayer = .green
        redScore = 1
        greenScore = 1
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
        
        //direct infection (infection spread through pointing at next zombieVirus)
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
        
        //indirect infection (infection spread through bordering zombieVirus pointing to an infected zombeVirus)
            //indirect infect from above
        if let indirect = getZombieVirus(atRow: from.row - 1, col: from.col) {
            if indirect.direction == .south {
                peopleToInfect.append(indirect)
            }
        }
            //indirect infect from below
        if let indirect = getZombieVirus(atRow: from.row + 1, col: from.col) {
            if indirect.direction == .north {
                peopleToInfect.append(indirect)
            }
        }
            //indirect infect from left
        if let indirect = getZombieVirus(atRow: from.row, col: from.col - 1) {
            if indirect.direction == .east {
                peopleToInfect.append(indirect)
            }
        }
            //indirect infect from right
        if let indirect = getZombieVirus(atRow: from.row, col: from.col + 1) {
            if indirect.direction == .west {
                peopleToInfect.append(indirect)
            }
        }
        //if our ZombieVirus optional unwraps into a value (as it should), loop through people to infect
        for case let zombieVirus? in peopleToInfect {
            //if current zombieVirus within peopleToInfect array has different color than the color of zombieVirus we passed in as argument to infect (note the *from* argument label), change color to that color (from the *from* argument label)
            if zombieVirus.color != from.color {
                zombieVirus.color = from.color
                peopleBeingInfected += 1
                //we want to make sure this async task runs on our main thread to ensure smooth UI update/rendering
                Task { @MainActor in
                    //recursive call of infect on current zombieVirus node in our loop
                    try await Task.sleep(for: .milliseconds(50))
                    peopleBeingInfected -= 1
                    infect(from: zombieVirus)
                }
               
            }
        }
        
        updateScores()
    }
    
    func rotate(zombieVirus: ZombieVirus) {
        //node has to be current player's color to change - this prevents clicking on other player's infected as well as non-infected nodes and spreading those items
        guard zombieVirus.color == currentPlayer else { return }
        //must wait until current infection wave is finished before we can take action
        guard peopleBeingInfected == 0 else { return }
        guard winner == nil else { return }
        objectWillChange.send()
        
        zombieVirus.direction = zombieVirus.direction.next
        
        infect(from: zombieVirus)
    }
    
    func changePlayer() {
        if currentPlayer == .green {
            currentPlayer = .red
        } else {
            currentPlayer = .green
        }
    }
    
    func updateScores() {
        //we capture updated score values here while looping through grid and only update redScore and greenScore directly once at the end.
            //if we were to update redScore and greenScore directly when looping over the grid we would be calling objectWillChange() for each grid cell potentially versus calling it twice at the end of the loop
        var newRedScore = 0
        var newGreenScore = 0
        
        for row in grid {
            for zombieVirus in row {
                if zombieVirus.color == .red {
                    newRedScore += 1
                } else if zombieVirus.color == .green {
                    newGreenScore += 1
                }
            }
        }
        
        redScore = newRedScore
        greenScore = newGreenScore
        
        //logic for end of turn or end of game
        if peopleBeingInfected == 0 {
            withAnimation(.spring()) {
                if redScore == 0 {
                    //green wins!
                    winner = "Green"
                    
                } else if greenScore == 0 {
                    //red wins!
                    winner = "Red"
                } else {
                    changePlayer()
                }
            }
        }
    }
}
