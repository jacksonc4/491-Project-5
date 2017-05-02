//
//  QuizScreen.swift
//  Quiz Game
//
//  Created by Curtis Jackson on 4/23/17.
//  Copyright © 2017 491 A5. All rights reserved.
//

import UIKit

struct defaultValue {
    var icon:UIImage!
    var name:String!
    var score:Int!
    
}

class QuizScreen: UIViewController {
    @IBOutlet weak var questionField: UIView!
    @IBOutlet weak var answerA: UIView!
    @IBOutlet weak var answerB: UIView!
    @IBOutlet weak var answerC: UIView!
    @IBOutlet weak var answerD: UIView!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    @IBOutlet weak var playAgain: UIButton!
    
    var defaultValues:[defaultValue] = [defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P1", score: 0), defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P2", score: 0), defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P3", score: 0), defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P4", score: 0)]
    var passedData:[String]!
    var playerIcons:[UIImageView] = []
        var playerPictures:[UIImage] = [#imageLiteral(resourceName: "RedPlayerIcon.png"), #imageLiteral(resourceName: "BluePlayerIcon.png"), #imageLiteral(resourceName: "GreenPlayerIcon.png"), #imageLiteral(resourceName: "OrangePlayerIcon.png")]
    var nameLabels:[UILabel] = []
        var playerColors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange]
    var scoreLabels:[UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        playAgain.alpha = 0
        playAgain.isUserInteractionEnabled = false
        createPlayerIcons()
        formatGameFields()
        updatePlayers()
        addGestureRecognizers()
       
    }
    
    func updatePlayers() {
        for i in 0..<passedData.count {
            playerIcons[i].alpha = 1
            playerIcons[i].image = playerPictures[i]
            nameLabels[i].textColor = playerColors[i]
            scoreLabels[i].textColor = UIColor.black
            
        }
        
    }
    
    func formatGameFields() {
        questionField.layer.cornerRadius = 5
        answerA.layer.cornerRadius = 5
        answerB.layer.cornerRadius = 5
        answerC.layer.cornerRadius = 5
        answerD.layer.cornerRadius = 5
        playAgain.layer.cornerRadius = 10
        
            questionField.layer.masksToBounds = true
            answerA.layer.masksToBounds = true
            answerB.layer.masksToBounds = true
            answerC.layer.masksToBounds = true
            answerD.layer.masksToBounds = true
            playAgain.layer.masksToBounds = true
        
    }

    func createPlayerIcons() {
        let screenSize = view.frame.size
        let screenWidth = screenSize.width

        for i in 0..<4 {
            let blank = UIImageView(image: defaultValues[i].icon)
            let scoreLabel = UILabel()
            let nameLabel = UILabel()

            let x_position = CGFloat((Int(screenWidth)/2) - (4 * 79) / 2 + (i * 79))
            let frame = CGRect(x: x_position, y: 200, width: 78, height: 128)
                blank.frame = CGRect(x: 0, y: 0, width: 78, height: 92)
                blank.alpha = 0.75
                nameLabel.frame = CGRect(x: 0, y: blank.center.y, width: 78, height: 50)
                nameLabel.font = UIFont.systemFont(ofSize: 28)
                nameLabel.text = defaultValues[i].name
                nameLabel.textColor = UIColor.lightGray
                nameLabel.textAlignment = NSTextAlignment.center
                scoreLabel.frame = CGRect(x: 0, y: 92, width: 78, height: 36)
                scoreLabel.font = UIFont.systemFont(ofSize: 32)
                scoreLabel.text = "\(defaultValues[i].score!)"
                scoreLabel.textColor = UIColor.lightGray
                scoreLabel.textAlignment = NSTextAlignment.center
                    blank.tag = i
                    nameLabel.tag = i
                    scoreLabel.tag = i
            
                playerIcons.append(blank)
                nameLabels.append(nameLabel)
                scoreLabels.append(scoreLabel)
            
            let containerView = UIView()
                containerView.frame = frame
                view.addSubview(containerView)
                    containerView.addSubview(blank)
                    containerView.addSubview(nameLabel)
                    containerView.addSubview(scoreLabel)
            
        }
        
    }
    
    func addGestureRecognizers() {
        let pickA = UITapGestureRecognizer(target: self, action: #selector(answerASelected))
            pickA.numberOfTapsRequired = 1
            answerA.addGestureRecognizer(pickA)
        
        let pickB = UITapGestureRecognizer(target: self, action: #selector(answerBSelected))
            pickB.numberOfTapsRequired = 1
            answerB.addGestureRecognizer(pickB)
        
        let pickC = UITapGestureRecognizer(target: self, action: #selector(answerCSelected))
            pickC.numberOfTapsRequired = 1
            answerC.addGestureRecognizer(pickC)
        
        let pickD = UITapGestureRecognizer(target: self, action: #selector(answerDSelected))
            pickD.numberOfTapsRequired = 1
            answerD.addGestureRecognizer(pickD)
        
    }
    
    func answerASelected() { //Determine selection color by player position in passedData array?
        print("Selected answer A")
        self.answerA.backgroundColor = playerColors[0]
        self.answerB.backgroundColor = UIColor.lightGray
        self.answerC.backgroundColor = UIColor.lightGray
        self.answerD.backgroundColor = UIColor.lightGray
        
    }
    
    func answerBSelected() {
        print("Selected answer B")
        self.answerA.backgroundColor = UIColor.lightGray
        self.answerB.backgroundColor = playerColors[0]
        self.answerC.backgroundColor = UIColor.lightGray
        self.answerD.backgroundColor = UIColor.lightGray
        
    }
    
    func answerCSelected() {
        print("Selected answer C")
        self.answerA.backgroundColor = UIColor.lightGray
        self.answerB.backgroundColor = UIColor.lightGray
        self.answerC.backgroundColor = playerColors[0]
        self.answerD.backgroundColor = UIColor.lightGray
        
    }
    
    func answerDSelected() {
        print("Selected answer D")
        self.answerA.backgroundColor = UIColor.lightGray
        self.answerB.backgroundColor = UIColor.lightGray
        self.answerC.backgroundColor = UIColor.lightGray
        self.answerD.backgroundColor = playerColors[0]
        
    }
    
}
