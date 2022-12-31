//
//  ContentView.swift
//  project-infect
//
//  Created by Jerald Stephenson on 12/23/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Text("GREEN: 0")
                
                Spacer()
                
                Text("Zombination")
                
                Spacer()
                
                Text("RED: 0")
            }
            .font(.system(size: 36).weight(.black))
            
            VStack{
                ForEach(0..<11, id: \.self) { row in
                    HStack {
                        ForEach(0..<22, id: \.self) { col in
                            let zombieVirus = ZombieVirus(row: 0, col: 0)
                            
                            ZombieVirusView(zombieVirus: zombieVirus) {
                                //rotate this zombieVirus
                            }
                        }
                    }
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
