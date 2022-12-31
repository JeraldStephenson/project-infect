//
//  ZombieVirusView.swift
//  project-infect
//
//  Created by Jerald Stephenson on 12/23/22.
//

import SwiftUI

struct ZombieVirusView: View {
    var zombieVirus: ZombieVirus
    var rotationAction: () -> Void
    //note we also use diff shapes (square vs circle) to help differentiate grid cells for players with colorblindness
    var image: String {
        switch zombieVirus.color {
        case .red:
            return "chevron.up.square.fill"
        case .green:
            return "chevron.up.circle.fill"
        default:
            return "chevron.up.circle"
        }
    }
    
    var body: some View {
        ZStack {
            Button(action: rotationAction) {
                Image(systemName: image)
                    .resizable()
                    .foregroundColor(zombieVirus.color)
            }
            //to prevent 3d button on macOS
            .buttonStyle(.plain)
            .frame(width: 32, height: 32)
            
            Rectangle()
                .fill(zombieVirus.color)
                .frame(width: 3, height: 8)
                .offset(y: -20)
        }
        .rotationEffect(.degrees(zombieVirus.direction.rotation))
    }
}

struct ZombieVirusView_Previews: PreviewProvider {
    static var previews: some View {
        ZombieVirusView(zombieVirus: ZombieVirus(row: 0, col: 0))    {
            
        }
    }
}
