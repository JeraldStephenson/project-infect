#  Dev Notes

Latest Progress:
       added player scores that update - we used a counter var that is incremented during infection adding to our toBeInfected array, and then decremented when our async Task of changing the UI colors is done. We will use this counter var to ensure that the infecting algo and updates to the UI rendering is done (counter var should be back to 0) before allowing for the next turn/action to take place. 
        updated the hardcoded redscore & greenscore in contentview to be our dynamic variables from our gameboard. added some style to these text

Next planned steps:
    
    need to set up player turns, only allow players to make moves on their turn
    need to add player scores that update
    restrict players to only be able to click on their color/zombieVirus strains
    need to prevent clicking on grey/non-infected nodes - this will prevent players from wasting their turn as well as the potential of 'spreading' non-infected nodes on infected nodes (making colored/infected nodes back to grey/non-infected)
    
    
    
Thoughts & Logic:
    If whole board is completely randomized - it can lead to unfair advantage from one player over another, so we will randomize half the board and then mirror it so that both sides are same

Completed tasks:
    finished algo for indirect infection. refactored algo to include a delay to each zombieVirus node color change when infection is spreading to give visual feedback to players on how the infection spreads from one node to the next
        allows nodes pointing to infected nodes to become infected themselves (indirect infection)
        basic algo that allows for rotating an zombieVirus node and point to a next node that it can infect and changes that node and connecting nodes to that player's color declaring that those nodes are now that player's zombie strain
        - side note: infected nodes pointing to other nodes will be infected, but currently there are nodes that can point to infected nodes, but will not be changed to infected also - we will want to have these nodes become "indirectly" infected by pointing to those infected nodes
