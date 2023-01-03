#  Dev Notes

Latest Progress:
       added resetting winner var, currentPlayer var, redScore and greenScore var back to what a new game board should have to our reset function.
       added a guard check to our rotate function to make sure there is no winner before executing function
       within ContentView, wrapped our game board view with a Z stack and added a winner view to that Z stack that we can have pop up if the board has a winner. Winner modal will also have a button to reset the board to play again.
Next planned steps:
    MVP done - 2 player and game rules working as intended
    
    add sound effects and maybe background music?
    add intro/menu screen
   extension features? - larger game board option would be easiest to implement first?
    
    
    
Thoughts & Logic:

    when adding sounds effects - want a sound per person infected or just one sound for whole turn?
    
    When doing larger grid views, have to make sure they still fit on intended screen sizes - will we need to have aspect ratios / UI scale ? Does this make it too hard to read and play as a user? (too far zoomed out feeling?)

    If whole board is completely randomized - it can lead to unfair advantage from one player over another, so we will randomize half the board and then mirror it so that both sides are same
    
Potential future features / ideas:
    intro/menu screen with options
    background music, sound effects
    replace grid cell styles to reflect people / infected/zombies 
    4 Player zombie strain - larger board
    Options to pick larger board size for 2 player?
    An additional mode/option that allows for a computer/pve as military that can (randomly?) clear areas of the board (killing infected) and sending in medical units that can cure infected ?

Completed tasks:
    need to set up player turns, only allow players to make moves on their turn
  
    restrict players to only be able to click on their color/zombieVirus strains
        - can add this feature as guard checks within our rotate function
    need to prevent clicking on grey/non-infected nodes - this will prevent players from wasting their turn as well as the potential of 'spreading' non-infected nodes on infected nodes (making colored/infected nodes back to grey/non-infected)
       added player scores that update - we used a counter var that is incremented during infection adding to our toBeInfected array, and then decremented when our async Task of changing the UI colors is done. We will use this counter var to ensure that the infecting algo and updates to the UI rendering is done (counter var should be back to 0) before allowing for the next turn/action to take place. 
        updated the hardcoded redscore & greenscore in contentview to be our dynamic variables from our gameboard. added some style to these text
    finished algo for indirect infection. refactored algo to include a delay to each zombieVirus node color change when infection is spreading to give visual feedback to players on how the infection spreads from one node to the next
        allows nodes pointing to infected nodes to become infected themselves (indirect infection)
        basic algo that allows for rotating an zombieVirus node and point to a next node that it can infect and changes that node and connecting nodes to that player's color declaring that those nodes are now that player's zombie strain
        - side note: infected nodes pointing to other nodes will be infected, but currently there are nodes that can point to infected nodes, but will not be changed to infected also - we will want to have these nodes become "indirectly" infected by pointing to those infected nodes
