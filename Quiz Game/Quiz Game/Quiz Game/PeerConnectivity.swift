//
//  PeerConnectivity.swift
//  Quiz Game
//
//  Created by Curtis Jackson on 4/23/17.
//  Copyright © 2017 491 A5. All rights reserved.
//

import UIKit

class PeerConnectivity {
    
    var players: [String]
    
    init() {
        //Always adds yourself at the start of game
        players = ["P1"]
        
    }
    
    func addPeer(player name: String) {
        self.players.append(name)
        
    }
    
    func dropPeer(player name: String) {
        self.players.remove(at: players.index(of: name)!)
        
    }
    
}
