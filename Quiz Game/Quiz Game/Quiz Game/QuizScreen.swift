//
//  QuizScreen.swift
//  Quiz Game
//
//  Created by Curtis Jackson on 4/23/17.
//  Copyright © 2017 491 A5. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Foundation

struct defaultValue {
    var icon:UIImage!
    var name:String!
    var score:Int!
    
}

struct questionData {
    var number:Int!
    var questionText:String!
    var options:[String]!
    var correctOption:String!
}

class QuizScreen: UIViewController, MCSessionDelegate {
    @IBOutlet weak var questionField: UIView!
    @IBOutlet weak var answerA: UIView!
    @IBOutlet weak var answerB: UIView!
    @IBOutlet weak var answerC: UIView!
    @IBOutlet weak var answerD: UIView!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    @IBOutlet weak var playAgain: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var DLabel: UILabel!
    @IBOutlet weak var CLabel: UILabel!
    @IBOutlet weak var BLabel: UILabel!
    @IBOutlet weak var ALabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    
    var defaultValues:[defaultValue] = [defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P1", score: 0), defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P2", score: 0), defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P3", score: 0), defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P4", score: 0)]
    var passedData:[String]!
    var playerIcons:[UIImageView] = []
        var playerPictures:[UIImage] = [#imageLiteral(resourceName: "RedPlayerIcon.png"), #imageLiteral(resourceName: "BluePlayerIcon.png"), #imageLiteral(resourceName: "GreenPlayerIcon.png"), #imageLiteral(resourceName: "OrangePlayerIcon.png")]
    var nameLabels:[UILabel] = []
        var playerColors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange]
    var scoreLabels:[UILabel] = []
    var bubbles:[UIImageView] = []
    var answerLabels:[UILabel] = []
    
    var session: MCSession!
    var peerID: MCPeerID!
    
    var questionStruct = questionData()
    var totalNumQuestions = 0
    var currentTopic = ""
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        qarray = []
        playAgain.alpha = 0
        playAgain.isUserInteractionEnabled = false
        createPlayerIcons()
        formatGameFields()
        updatePlayers()
        addGestureRecognizers()
        
        session.delegate = self
       
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        
        getQuestions()
        
        print(session.connectedPeers)
        print(peerID.displayName)
        
    }
    
    func updateTimer() {
        let remaining = 20 - counter
        self.timerLabel.text = String(remaining)
        counter += 1
        
        if (counter == 21) {
            counter = 0
            timer.invalidate()
        }
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
            
            let bubble = UIImageView(image: #imageLiteral(resourceName: "bubble.png"))
            let answerLabel = UILabel()
                bubble.frame = CGRect(x: 0, y: 0, width: 78, height: 50)
                bubble.isHidden = true
                    bubble.tag = i
                answerLabel.frame = CGRect(x: bubble.center.x - 10, y: bubble.center.y / 2 - 15, width: 39, height: 45)
                answerLabel.font = UIFont.boldSystemFont(ofSize: 24)
                    answerLabel.tag = i

            let x_position = CGFloat((Int(screenWidth)/2) - (4 * 79) / 2 + (i * 79))
            let frame = CGRect(x: x_position, y: 200, width: 78, height: 128)
            let frame2 = CGRect(x: x_position + 35, y: 150, width: 78, height: 128)
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
                bubbles.append(bubble)
                answerLabels.append(answerLabel)
            
            let containerView = UIView()
                containerView.frame = frame
                view.addSubview(containerView)
                    containerView.addSubview(blank)
                    containerView.addSubview(nameLabel)
                    containerView.addSubview(scoreLabel)
            
            let answerView = UIView()
                answerView.frame = frame2
                view.addSubview(answerView)
                    answerView.addSubview(bubble)
                    answerView.addSubview(answerLabel)
            
        }
        
    }
    
    func addGestureRecognizers() {
        let pickA = UITapGestureRecognizer(target: self, action: #selector(answerASelected))
            pickA.numberOfTapsRequired = 1
            answerA.addGestureRecognizer(pickA)
        
        let confirmA = UITapGestureRecognizer(target: self, action: #selector(answerASubmit))
            confirmA.numberOfTapsRequired = 2
            answerA.addGestureRecognizer(confirmA)
        
        let pickB = UITapGestureRecognizer(target: self, action: #selector(answerBSelected))
            pickB.numberOfTapsRequired = 1
            answerB.addGestureRecognizer(pickB)
        
        let confirmB = UITapGestureRecognizer(target: self, action: #selector(answerBSubmit))
            confirmB.numberOfTapsRequired = 2
            answerB.addGestureRecognizer(confirmB)
        
        let pickC = UITapGestureRecognizer(target: self, action: #selector(answerCSelected))
            pickC.numberOfTapsRequired = 1
            answerC.addGestureRecognizer(pickC)
        
        let confirmC = UITapGestureRecognizer(target: self, action: #selector(answerCSubmit))
            confirmC.numberOfTapsRequired = 2
            answerC.addGestureRecognizer(confirmC)
        
        let pickD = UITapGestureRecognizer(target: self, action: #selector(answerDSelected))
            pickD.numberOfTapsRequired = 1
            answerD.addGestureRecognizer(pickD)
        
        let confirmD = UITapGestureRecognizer(target: self, action: #selector(answerDSubmit))
            confirmD.numberOfTapsRequired = 2
            answerD.addGestureRecognizer(confirmD)
        
    }
    
    var qarray = [String]()
    
    func getQuestions() {
        
        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json"
        let url = URL(string: urlString)
        let urlsession = URLSession.shared
        
        // create a data task
        let task = urlsession.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let result = data{
                
                print("inside get JSON")
                print(result)
                do{
                    let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                    
                    if let dictionary = json as? [String:Any]{
                        self.totalNumQuestions = dictionary["numberOfQuestions"] as! Int
                        self.currentTopic = dictionary["topic"] as! String
                        if let questions = dictionary["questions"] as? [[String:Any]] {
                            
                            let currentQuestion = questions[0] as! [String:Any]
                            let questionText = currentQuestion["questionSentence"] as! String
                            let number = currentQuestion["number"] as! Int
                            let correctOption = currentQuestion["correctOption"] as! String
                            let options = currentQuestion["options"] as! [String:Any]
                            
                            var tempArray = [String]()
                            tempArray.append(options["A"] as! String)
                            tempArray.append(options["B"] as! String)
                            tempArray.append(options["C"] as! String)
                            tempArray.append(options["D"] as! String)
                            
                            self.questionStruct = questionData(number: number, questionText: questionText, options: tempArray, correctOption: correctOption)
                            
                        }
                        

                    }
                    print(self.questionStruct)
                    self.updateQuestion()
                }
                catch{
                    print("Error")
                }
            }
            
        })
        // always call resume() to start
        task.resume()
    }
    
    func updateQuestion() {
        self.ALabel.text = questionStruct.options[0]
        self.BLabel.text = questionStruct.options[1]
        self.CLabel.text = questionStruct.options[2]
        self.DLabel.text = questionStruct.options[3]
        self.questionLabel.text = questionStruct.questionText
        self.gameStatus.text = currentTopic
        self.questionNumber.text = "Question \(questionStruct.number!)/\(totalNumQuestions)"
        
    }
    
    func answerASelected() { //Determine selection color by player position in passedData array?
        self.answerA.backgroundColor = playerColors[0].withAlphaComponent(0.75)
        self.answerB.backgroundColor = UIColor.lightGray
        self.answerC.backgroundColor = UIColor.lightGray
        self.answerD.backgroundColor = UIColor.lightGray
        
    }
    
    func answerASubmit() {
        self.bubbles[0].isHidden = false
        self.answerA.backgroundColor = playerColors[0]
        self.answerLabels[0].text = "A"
        self.answerLabels[0].textColor = playerColors[0]
        removeAllGestureRecognizers()
        
    }
    
    func answerBSelected() {
        self.answerA.backgroundColor = UIColor.lightGray
        self.answerB.backgroundColor = playerColors[0].withAlphaComponent(0.65)
        self.answerC.backgroundColor = UIColor.lightGray
        self.answerD.backgroundColor = UIColor.lightGray
        
    }
    
    func answerBSubmit() {
        self.bubbles[0].isHidden = false
        self.answerB.backgroundColor = playerColors[0]
        self.answerLabels[0].text = "B"
        self.answerLabels[0].textColor = playerColors[0]
        removeAllGestureRecognizers()
        
    }
    
    func answerCSelected() {
        self.answerA.backgroundColor = UIColor.lightGray
        self.answerB.backgroundColor = UIColor.lightGray
        self.answerC.backgroundColor = playerColors[0].withAlphaComponent(0.65)
        self.answerD.backgroundColor = UIColor.lightGray
        
    }
    
    func answerCSubmit() {
        self.bubbles[0].isHidden = false
        self.answerC.backgroundColor = playerColors[0]
        self.answerLabels[0].text = "C"
        self.answerLabels[0].textColor = playerColors[0]
        removeAllGestureRecognizers()

    }
    
    func answerDSelected() {
        self.answerA.backgroundColor = UIColor.lightGray
        self.answerB.backgroundColor = UIColor.lightGray
        self.answerC.backgroundColor = UIColor.lightGray
        self.answerD.backgroundColor = playerColors[0].withAlphaComponent(0.65)
        
    }
    
    func answerDSubmit() {
        self.bubbles[0].isHidden = false
        self.answerD.backgroundColor = playerColors[0]
        self.answerLabels[0].text = "D"
        self.answerLabels[0].textColor = playerColors[0]
        removeAllGestureRecognizers()
        
    }
    
    func removeAllGestureRecognizers() {
        self.answerA.gestureRecognizers?.forEach(answerA.removeGestureRecognizer(_:))
        self.answerB.gestureRecognizers?.forEach(answerB.removeGestureRecognizer(_:))
        self.answerC.gestureRecognizers?.forEach(answerC.removeGestureRecognizer(_:))
        self.answerD.gestureRecognizers?.forEach(answerD.removeGestureRecognizer(_:))
        
    }
    
    //**********************************************************
    // required functions for MCSessionDelegate
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        // this needs to be run on the main thread
        DispatchQueue.main.async(execute: {
            
        })
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
        
    }
    //**********************************************************
    
}
