//
//  ViewController.swift
//  Quiz Game
//
//  Created by Curtis Jackson on 4/23/17.
//  Copyright © 2017 491 A5. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gamePlayerCount: UISegmentedControl!
    @IBOutlet weak var beginQuiz: UIButton!
    let peers = PeerConnectivity()
        var tempPlayerCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beginQuiz.layer.borderColor = UIColor.blue.cgColor
        beginQuiz.layer.borderWidth = 1
        beginQuiz.layer.cornerRadius = 3
        beginQuiz.layer.masksToBounds = true
        
    }
    
    @IBAction func findPeers(_ sender: UIBarButtonItem) {
        
        if peers.players.count < 4 {
            tempPlayerCount += 1
            peers.addPeer(player: "P\(tempPlayerCount)")
            print("Player " + peers.players.last! + " added")
            
        } else {
            let tooManyPlayers = UIAlertController(title: "Player Limit Reached", message: "You can only play with up to four people.", preferredStyle: .alert)
            let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                tooManyPlayers.addAction(myAction)
                present(tooManyPlayers, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func beginQuiz(_ sender: UIButton) {
        switch gamePlayerCount.selectedSegmentIndex {
        case 0:
            if peers.players.count > 1 {
                let tooManyPlayers = UIAlertController(title: "Too Many Players", message: "Select a multiplayer game instead.", preferredStyle: .alert)
                let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    tooManyPlayers.addAction(myAction)
                    present(tooManyPlayers, animated: true, completion: nil)

            } else {
                performSegue(withIdentifier: "proceedToGame", sender: nil)
                
            }
            
        case 1:
            //Do multiplayer game stuff
            if peers.players.count == 1 {
                let insufficientConnections = UIAlertController(title: "No Connected Players", message: "You cannot play a multiplayer game by yourself.", preferredStyle: .alert)
                let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    insufficientConnections.addAction(myAction)
                    present(insufficientConnections, animated: true, completion: nil)
                
            } else {
                print("\(peers.players.count) player game selected. Players are:")
                for player in peers.players {
                    print(player)
                    
                }
                
                performSegue(withIdentifier: "proceedToGame", sender: self)
                
            }
            
        default:
            break
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScreen = segue.destination as! QuizScreen
            nextScreen.passedData = peers.players
            print("Sent player data to game screen")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
