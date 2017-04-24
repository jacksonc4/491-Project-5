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
    
    @IBOutlet weak var p1Image: UIImageView!
    @IBOutlet weak var p2Image: UIImageView!
    @IBOutlet weak var p3Image: UIImageView!
    @IBOutlet weak var p4Image: UIImageView!
       
    @IBOutlet weak var p1Score: UILabel!
    @IBOutlet weak var p2Score: UILabel!
    @IBOutlet weak var p3Score: UILabel!
    @IBOutlet weak var p4Score: UILabel!
    
    var playerIcons:[UIImageView]!
    var scoreLabels:[UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerIcons = [p1Image, p2Image, p3Image, p4Image]
        scoreLabels = [p1Score, p2Score, p3Score, p4Score]
        createPlayerIcons()
        showPlayers()
    }
    
    //Change to be of type player
    var playerArray: [String] = []
    
    func showPlayers() {
        for player in playerArray {
            print(player)
            
        }
        
    }
    
    func createPlayerIcons() {
        
        for player in playerIcons {
            player.image = #imageLiteral(resourceName: "placeholderPlayerIcon.png")
            player.alpha = 0.75
                
        }
        
        for score in scoreLabels {
            score.text = "0"
            score.alpha = 0.65
            
        }
        
    }
    
}
