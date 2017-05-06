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
import CoreMotion

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
    
    var receivedSession: MCSession!
    var receivedPeerID: MCPeerID!
    
    var defaultValues:[defaultValue] = [defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P1", score: 0), defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P2", score: 0), defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P3", score: 0), defaultValue(icon: #imageLiteral(resourceName: "placeholderPlayerIcon.png"), name: "P4", score: 0)]
    var passedData:[String]!
    var playerIcons:[UIImageView] = []
        var playerPictures:[UIImage] = [#imageLiteral(resourceName: "RedPlayerIcon.png"), #imageLiteral(resourceName: "BluePlayerIcon.png"), #imageLiteral(resourceName: "GreenPlayerIcon.png"), #imageLiteral(resourceName: "OrangePlayerIcon.png")]
    var nameLabels:[UILabel] = []
        var playerColors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange]
    var scoreLabels:[UILabel] = []
    var bubbles:[UIImageView] = []
    var answerLabels:[UILabel] = []
    
    var questionStruct = questionData()
    var currentJson = 0
    var totalNumQuestions = 0
    var currentQuestionNum = -1
    var currentTopic = ""
    var timer = Timer()
    var counter = 0
    
    var numPlayers = 1
    var submittedAnswers = 0
    var thisPlayerAnswer = ""
    var score = 0
    
    var motionManager: CMMotionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        currentJson += 1
        qarray = []
        playAgain.alpha = 1
        playAgain.isUserInteractionEnabled = true
        playAgain.isHidden = true
        createPlayerIcons()
        formatGameFields()
        updatePlayers()
        addGestureRecognizers()
        
        self.getQuestions()
        
        print("Session info from Quiz Screen")
        print("Connected peers: \(receivedSession.connectedPeers.count)")
        numPlayers += receivedSession.connectedPeers.count
        print("Total players passed to Quiz Screen: \(passedData)")
        print(receivedPeerID.displayName)
        
        self.motionManager = CMMotionManager()
        
        self.motionManager.deviceMotionUpdateInterval = 1.0/60.0
        self.motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)
        
        monitorDeviceOrientation()
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateDeviceMotion), userInfo: nil, repeats: true)
        
        
    }
    
    func updateDeviceMotion(){
        
        if let data = self.motionManager.deviceMotion {
            
            // orientation of body relative to a reference frame
            let attitude = data.attitude
            
            let userAcceleration = data.userAcceleration
            
            let gravity = data.gravity
            let rotation = data.rotationRate
            
            print("pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
            
        }
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }

    func updateTimer() {
            updateQuestion()
            let remaining = 20 - counter
            self.timerLabel.text = String(remaining)
            counter += 1
            
            if (counter == 21) {
                counter = 0
                timer.invalidate()
                removeAllGestureRecognizers()
                questionLabel.text = "Time's up! Correct answer: \(qarray[currentQuestionNum].correctOption!)"
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.pauseGame), userInfo: nil, repeats: true)
            }

    }
    
    func pauseGame() {
        counter += 1
        let remaining = 4 - counter
        self.timerLabel.text = String(remaining)
        
        if counter == 4 {
            counter = 0
            timer.invalidate()
            addGestureRecognizers()
            currentQuestionNum += 1
            if currentQuestionNum < qarray.count && currentQuestionNum != qarray.count {
                updateQuestion()
                resetState()
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            } else {
                playAgain.isHidden = false
                currentQuestionNum = -1
                // player win logic here
                questionLabel.text = "Winner: Player 1!" // temp
                
            }
            
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
                answerLabel.frame = CGRect(x: bubble.center.x - 10, y: bubble.center.y / 2 - 15, width: 39, height: 45)
                answerLabel.font = UIFont.boldSystemFont(ofSize: 24)

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
                    scoreLabel.tag = i+1
            
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
    
    var qarray = [questionData]()
    
    func getQuestions() {
        
        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz\(currentJson).json"
        let url = URL(string: urlString)
        let urlsession = URLSession.shared
        
        
        if currentQuestionNum < totalNumQuestions {
            currentQuestionNum += 1

            // create a data task
            let task = urlsession.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if let result = data{
                    
                    print("inside get JSON")
                    print(result)
                    do{
                        let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                        
                        if let dictionary = json as? [String:Any]{
                              self.currentTopic = dictionary["topic"] as! String
                            if let questions = dictionary["questions"] as? [[String:Any]] {
                                
                                for question in questions {
                                    let questionText = question["questionSentence"] as! String
                                    let number = question["number"] as! Int
                                    let correctOption = question["correctOption"] as! String
                                    let options = question["options"] as! [String:Any]
                                    
                                    var tempArray = [String]()
                                    tempArray.append(options["A"] as! String)
                                    tempArray.append(options["B"] as! String)
                                    tempArray.append(options["C"] as! String)
                                    tempArray.append(options["D"] as! String)
                                    
                                    self.questionStruct = questionData(number: number, questionText: questionText, options: tempArray, correctOption: correctOption)
                                    
                                    self.qarray.append(self.questionStruct)
                                }
                                
                            }
                        }
                        print(self.qarray)
                        self.updateQuestion()
                        
                    }
                    catch{
                        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json"
                        let url = URL(string: urlString)
                        let urlsession = URLSession.shared
                        
                        self.currentJson = 1
                            // create a data task
                            let task = urlsession.dataTask(with: url!, completionHandler: { (data, response, error) in
                                
                                if let result = data{
                                    
                                    print("inside get JSON")
                                    print(result)
                                    do{
                                        let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                                        
                                        if let dictionary = json as? [String:Any]{
                                            self.currentTopic = dictionary["topic"] as! String
                                            if let questions = dictionary["questions"] as? [[String:Any]] {
                                                
                                                for question in questions {
                                                    let questionText = question["questionSentence"] as! String
                                                    let number = question["number"] as! Int
                                                    let correctOption = question["correctOption"] as! String
                                                    let options = question["options"] as! [String:Any]
                                                    
                                                    var tempArray = [String]()
                                                    tempArray.append(options["A"] as! String)
                                                    tempArray.append(options["B"] as! String)
                                                    tempArray.append(options["C"] as! String)
                                                    tempArray.append(options["D"] as! String)
                                                    
                                                    self.questionStruct = questionData(number: number, questionText: questionText, options: tempArray, correctOption: correctOption)
                                                    
                                                    self.qarray.append(self.questionStruct)
                                                }
                                                
                                            }
                                        }
                                        print(self.qarray)
                                        self.updateQuestion()
                                        
                                    }
                                    catch{
                                        print("Error")
                                    }
                                }
                            })
                            // always call resume() to start
                            task.resume()
                            self.startTimer()
                            
                    }
                }
            })
            // always call resume() to start
            task.resume()
            self.startTimer()
            
        } else {
            
        }

    }


    func checkSubmittedAnswers() {
        if (numPlayers == submittedAnswers) {
            timer.invalidate()
            counter = 0
            removeAllGestureRecognizers()
            questionLabel.text = "Time's up! Correct answer: \(qarray[currentQuestionNum].correctOption!)"
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.pauseGame), userInfo: nil, repeats: true)
            pauseGame()
            if (thisPlayerAnswer == qarray[currentQuestionNum].correctOption!) {
                let scorelabel = self.view.viewWithTag(1) as! UILabel
                
                score += 1
                
                scorelabel.text = String(score)
            }
            
            thisPlayerAnswer = ""
            submittedAnswers = 0
        }
    }
    
    func updateQuestion() {
        print(qarray[currentQuestionNum])
        self.ALabel.text = qarray[currentQuestionNum].options[0]
        self.BLabel.text = qarray[currentQuestionNum].options[1]
        self.CLabel.text = qarray[currentQuestionNum].options[2]
        self.DLabel.text = qarray[currentQuestionNum].options[3]
        self.questionLabel.text = qarray[currentQuestionNum].questionText
        self.gameStatus.text = currentTopic
        self.questionNumber.text = "Question \(qarray[currentQuestionNum].number!)/\(qarray.count)"
        
    }
    
    func answerASelected() {
        self.answerA.backgroundColor = playerColors[passedData.index(of: receivedPeerID.displayName)!].withAlphaComponent(0.75)
        self.answerB.backgroundColor = UIColor.lightGray
        self.answerC.backgroundColor = UIColor.lightGray
        self.answerD.backgroundColor = UIColor.lightGray

    }
    
    func answerASubmit() {
        let answerToSend = "A"
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: answerToSend)
        
            do {
                try self.receivedSession.send(dataToSend, toPeers: self.receivedSession.connectedPeers, with: .unreliable)
            }
            
            catch let error {
                print("[[Error]] \(error)")
            
            }

        updateGameView(answer: "A", id: receivedPeerID)
        removeAllGestureRecognizers()
        submittedAnswers += 1
        thisPlayerAnswer = "A"
        checkSubmittedAnswers()
    }
    
    func answerBSelected() {
        self.answerA.backgroundColor = UIColor.lightGray
        self.answerB.backgroundColor = playerColors[passedData.index(of: receivedPeerID.displayName)!].withAlphaComponent(0.65)
        self.answerC.backgroundColor = UIColor.lightGray
        self.answerD.backgroundColor = UIColor.lightGray

    }
    
    func answerBSubmit() {
        let answerToSend = "B"
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: answerToSend)
        
            do {
                try self.receivedSession.send(dataToSend, toPeers: self.receivedSession.connectedPeers, with: .unreliable)
            }
            
            catch let error {
                print("[[Error]] \(error)")
            
            }

        updateGameView(answer: "B", id: receivedPeerID)
        removeAllGestureRecognizers()
        submittedAnswers += 1
        thisPlayerAnswer = "B"
        checkSubmittedAnswers()
    }
    
    func answerCSelected() {
        self.answerA.backgroundColor = UIColor.lightGray
        self.answerB.backgroundColor = UIColor.lightGray
        self.answerC.backgroundColor = playerColors[passedData.index(of: receivedPeerID.displayName)!].withAlphaComponent(0.65)
        self.answerD.backgroundColor = UIColor.lightGray
        
    }
    
    func answerCSubmit() {
        let answerToSend = "C"
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: answerToSend)
        
            do {
                try self.receivedSession.send(dataToSend, toPeers: self.receivedSession.connectedPeers, with: .unreliable)
            }
            
            catch let error {
                print("[[Error]] \(error)")
            
            }

        updateGameView(answer: "C", id: receivedPeerID)
        removeAllGestureRecognizers()
        submittedAnswers += 1
        thisPlayerAnswer = "C"
        checkSubmittedAnswers()
    }
    
    func answerDSelected() {
        self.answerA.backgroundColor = UIColor.lightGray
        self.answerB.backgroundColor = UIColor.lightGray
        self.answerC.backgroundColor = UIColor.lightGray
        self.answerD.backgroundColor = playerColors[passedData.index(of: receivedPeerID.displayName)!].withAlphaComponent(0.65)
     
    }
    
    func answerDSubmit() {
        let answerToSend = "D"
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: answerToSend)
        
            do {
                try self.receivedSession.send(dataToSend, toPeers: self.receivedSession.connectedPeers, with: .unreliable)
            }
            
            catch let error {
                print("[[Error]] \(error)")
            
            }

        updateGameView(answer: "D", id: receivedPeerID)
        removeAllGestureRecognizers()
        submittedAnswers += 1
        thisPlayerAnswer = "D"
        checkSubmittedAnswers()
    }
    
    func updateGameView(answer: String, id: MCPeerID) {
        if id == receivedPeerID {
        switch answer {
            case "A":
                self.bubbles[passedData.index(of: id.displayName)!].isHidden = false
                self.answerA.backgroundColor = playerColors[passedData.index(of: id.displayName)!]
                self.answerLabels[passedData.index(of: id.displayName)!].text = "A"
                self.answerLabels[passedData.index(of: id.displayName)!].textColor = playerColors[passedData.index(of: id.displayName)!]
            
            case "B":
                self.bubbles[passedData.index(of: id.displayName)!].isHidden = false
                self.answerB.backgroundColor = playerColors[passedData.index(of: id.displayName)!]
                self.answerLabels[passedData.index(of: id.displayName)!].text = "B"
                self.answerLabels[passedData.index(of: id.displayName)!].textColor = playerColors[passedData.index(of: id.displayName)!]
            
            case "C":
                self.bubbles[passedData.index(of: id.displayName)!].isHidden = false
                self.answerC.backgroundColor = playerColors[passedData.index(of: id.displayName)!]
                self.answerLabels[passedData.index(of: id.displayName)!].text = "C"
                self.answerLabels[passedData.index(of: id.displayName)!].textColor = playerColors[passedData.index(of: id.displayName)!]
            
            case "D":
                self.bubbles[passedData.index(of: id.displayName)!].isHidden = false
                self.answerD.backgroundColor = playerColors[passedData.index(of: id.displayName)!]
                self.answerLabels[passedData.index(of: id.displayName)!].text = "D"
                self.answerLabels[passedData.index(of: id.displayName)!].textColor = playerColors[passedData.index(of: id.displayName)!]
            
            default:
                break;
            
            }
            
        } else {
            
                switch answer {
                case "A":
                self.bubbles[passedData.index(of: id.displayName)!].isHidden = false
                self.answerA.backgroundColor = playerColors[passedData.index(of: id.displayName)!]
                self.answerLabels[passedData.index(of: id.displayName)!].text = "A"
                self.answerLabels[passedData.index(of: id.displayName)!].textColor = playerColors[passedData.index(of: id.displayName)!]
                
                case "B":
                self.bubbles[passedData.index(of: id.displayName)!].isHidden = false
                self.answerB.backgroundColor = playerColors[passedData.index(of: id.displayName)!]
                self.answerLabels[passedData.index(of: id.displayName)!].text = "B"
                self.answerLabels[passedData.index(of: id.displayName)!].textColor = playerColors[passedData.index(of: id.displayName)!]
                
                case "C":
                self.bubbles[passedData.index(of: id.displayName)!].isHidden = false
                self.answerC.backgroundColor = playerColors[passedData.index(of: id.displayName)!]
                self.answerLabels[passedData.index(of: id.displayName)!].text = "C"
                self.answerLabels[passedData.index(of: id.displayName)!].textColor = playerColors[passedData.index(of: id.displayName)!]
                
                case "D":
                self.bubbles[passedData.index(of: id.displayName)!].isHidden = false
                self.answerD.backgroundColor = playerColors[passedData.index(of: id.displayName)!]
                self.answerLabels[passedData.index(of: id.displayName)!].text = "D"
                self.answerLabels[passedData.index(of: id.displayName)!].textColor = playerColors[passedData.index(of: id.displayName)!]
                
                default:
                break;
                
            }
            
        }
        
    }
    
    func resetState() {
        self.bubbles[0].isHidden = true
        self.answerA.backgroundColor = UIColor.lightGray
        self.answerB.backgroundColor = UIColor.lightGray
        self.answerC.backgroundColor = UIColor.lightGray
        self.answerD.backgroundColor = UIColor.lightGray
    }
    
    func removeAllGestureRecognizers() {
        self.answerA.gestureRecognizers?.forEach(answerA.removeGestureRecognizer(_:))
        self.answerB.gestureRecognizers?.forEach(answerB.removeGestureRecognizer(_:))
        self.answerC.gestureRecognizers?.forEach(answerC.removeGestureRecognizer(_:))
        self.answerD.gestureRecognizers?.forEach(answerD.removeGestureRecognizer(_:))
        
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        
        let testOutput = UIAlertController(title: "Restart?", message: "", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: restartGame)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        testOutput.addAction(myAction)
        testOutput.addAction(cancel)
        self.present(testOutput, animated: true, completion: nil)

    }
    
    func restartGame(action: UIAlertAction) {
        totalNumQuestions = 0
        currentQuestionNum = -1
        currentTopic = ""
        counter = 0
        submittedAnswers = 0
        thisPlayerAnswer = ""
        score = 0
        
        currentJson += 1
        qarray = []
        
        self.getQuestions()
        
        playAgain.isHidden = true
        
        print("Session info from Quiz Screen")
        print("Connected peers: \(receivedSession.connectedPeers.count)")
        numPlayers += receivedSession.connectedPeers.count
        print("Total players passed to Quiz Screen: \(passedData)")
        print(receivedPeerID.displayName)
    }
    
    /***Required for Session Delegate***/
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive newData: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async(execute: {
            
            if let receivedAnswer = NSKeyedUnarchiver.unarchiveObject(with: newData) as? String{
                self.updateGameView(answer: receivedAnswer, id: peerID)
                
            }
            
        })
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    /***End of Session Delegate Functions***/
    
    /***Required functions for MCBrowser ViewController Delegate***/
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        
    }
    /***End of MCBrowser ViewController Delegate Functions***/
    
    override func viewWillDisappear(_ animated: Bool) {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    func monitorDeviceOrientation(){
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func orientationChanged(_ notification: Notification){
        print(UIDevice.current.orientation.rawValue)
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            print("shaked")
        }
        
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("motionEnded")
    }
    
}
