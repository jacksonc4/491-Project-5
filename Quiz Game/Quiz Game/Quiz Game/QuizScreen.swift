//
//  QuizScreen.swift
//  Quiz Game
//
//  Created by Curtis Jackson on 4/23/17.
//  Copyright © 2017 491 A5. All rights reserved.
//

import UIKit

struct player {
    var name: String!
    var score: Int!
    var icon: UIImage!
    var answer: String!
    
}

class QuizScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPlayers()
    }
    
    var playerArray: [String] = []
    
    func showPlayers() {
        for player in playerArray {
            print(player)
            
        }
        
    }
    
    func createPlayerIcons() {
        let iconHeight = 95
        let iconWidth = 80
        
        for i in 0..<playerArray.count {
            //Draw the player icons
            
        }
        
    }
    
}
