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
   
    var passedData: [String]!
    var playerArray: [player]!
    var playerIcons:[UIImageView]!
    var scoreLabels:[UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        createPlayerIcons()
        showPlayers()
        
    }
    
    func createPlayerArray() {
        for name in passedData {
            playerArray.append(player(name: name, score: 0, icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), answer: nil))
            
        }
        
        print("Built player array")
        
    }
    
    func showPlayers() {
        for player in passedData {
            print(player)

        }

    }

    func createPlayerIcons() {
        let screenSize = view.frame.size
        let screenWidth = screenSize.width

        for i in 0..<4 {
            let blank = UIImageView(image: #imageLiteral(resourceName: "placeholderPlayerIcon.png"))
            let scoreLabel = UILabel()
            let nameLabel = UILabel()

            let x_position = CGFloat((Int(screenWidth)/2) - (4 * 79) / 2 + (i * 79))
            let frame = CGRect(x: x_position, y: 200, width: 78, height: 128)
                blank.frame = CGRect(x: 0, y: 0, width: 78, height: 92)
                blank.alpha = 0.75
                nameLabel.frame = CGRect(x: 0, y: blank.center.y, width: 78, height: 50)
                nameLabel.font = UIFont.systemFont(ofSize: 28)
                nameLabel.text = passedData[i]
                nameLabel.textColor = UIColor.lightGray
                nameLabel.textAlignment = NSTextAlignment.center
                scoreLabel.frame = CGRect(x: 0, y: 92, width: 78, height: 36)
                scoreLabel.font = UIFont.systemFont(ofSize: 32)
                scoreLabel.text = "0"
                scoreLabel.textColor = UIColor.lightGray
                scoreLabel.textAlignment = NSTextAlignment.center
                    blank.tag = i
                    nameLabel.tag = i
                    scoreLabel.tag = i
            
            let containerView = UIView()
                containerView.frame = frame
                view.addSubview(containerView)
                    containerView.addSubview(blank)
                    containerView.addSubview(nameLabel)
                    containerView.addSubview(scoreLabel)
            
        }
        
    }
    
}
