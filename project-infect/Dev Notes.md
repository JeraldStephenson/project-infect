#  Dev Notes

Latest Progress:
    basic algo that allows for rotating an zombieVirus node and point to a next node that it can infect and changes that node and connecting nodes to that player's color declaring that those nodes are now that player's zombie strain
        - side note: infected nodes pointing to other nodes will be infected, but currently there are nodes that can point to infected nodes, but will not be changed to infected also - we will want to have these nodes become "indirectly" infected by pointing to those infected nodes

Next planned steps:
    allows nodes pointing to infected nodes to become infected themselves (indirect infection)
    need to set up player turns, only allow players to make moves on their turn
    restrict players to only be able to click on their color/zombieVirus strains
    
    
    
Thoughts & Logic:
    If whole board is completely randomized - it can lead to unfair advantage from one player over another, so we will randomize half the board and then mirror it so that both sides are same

