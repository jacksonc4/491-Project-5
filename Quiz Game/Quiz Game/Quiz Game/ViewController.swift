//
//  ViewController.swift
//  Quiz Game
//
//  Created by Curtis Jackson on 4/23/17.
//  Copyright © 2017 491 A5. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {

    @IBOutlet weak var gamePlayerCount: UISegmentedControl!
    @IBOutlet weak var beginQuiz: UIButton!
    var session: MCSession!
    var peerID: MCPeerID!
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var broadcastMessage: Bool!
    
    var players:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beginQuiz.layer.borderColor = UIColor.blue.cgColor
        beginQuiz.layer.borderWidth = 1
        beginQuiz.layer.cornerRadius = 3
        beginQuiz.layer.masksToBounds = true
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser =  MCBrowserViewController(serviceType: "Quiz-Game", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "Quiz-Game", discoveryInfo: nil, session: session)

        assistant.start()
        session.delegate = self
        browser.delegate = self
        
        players.append(peerID.displayName)
        
        //Hide Autolayout Warning
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        
    }
    
    @IBAction func findPeers(_ sender: UIBarButtonItem) {
        present(browser, animated: true, completion: nil)
        
    }
    
    @IBAction func beginQuiz(_ sender: UIButton) {
        switch gamePlayerCount.selectedSegmentIndex {
            
        case 0:
            if session.connectedPeers.count > 0{
                let tooManyPlayers = UIAlertController(title: "Too Many Players", message: "Select a multiplayer game instead.", preferredStyle: .alert)
                let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    tooManyPlayers.addAction(myAction)
                    present(tooManyPlayers, animated: true, completion: nil)

            } else {
                self.performSegue(withIdentifier: "proceedToGame", sender: self)
            
            }
            
        case 1:
            //Do multiplayer game stuff
            if session.connectedPeers.count < 1 {
                let insufficientConnections = UIAlertController(title: "No Connected Players", message: "You cannot play a multiplayer game by yourself.", preferredStyle: .alert)
                let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    insufficientConnections.addAction(myAction)
                    present(insufficientConnections, animated: true, completion: nil)
                
            } else {
                print("\(session.connectedPeers.count) player game selected. Players are:")
                print(players)
                self.performSegue(withIdentifier: "proceedToGame", sender: self)
                
                DispatchQueue.main.async(execute: {
                    let broadcastMessage = "performSegue"
                    let data = NSKeyedArchiver.archivedData(withRootObject: broadcastMessage)
                    
                    do {
                        try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
                        
                    } catch let error {
                        print("[[Connection Error]] \(error)")
                        
                    }
                    
                })
                
            }
            
        default:
            break
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScreen = segue.destination as! QuizScreen
            nextScreen.passedData = players
            nextScreen.passedPeers.session = session
            nextScreen.passedPeers.peerID = peerID
            print("Sent player data to game screen")
        
    }
    
    /***Required for Session Delegate***/
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
            
        case .connected:
            if players.count < 4 {
                players.append(peerID.displayName)
                
            } else {
                let tooManyPlayers = UIAlertController(title: "Player Limit Reached", message: "You can only play with up to four people.", preferredStyle: .alert)
                let myAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    tooManyPlayers.addAction(myAction)
                    browser.present(tooManyPlayers, animated: true, completion: nil)
                
            }
            
        case .notConnected:
            print("Not Connected")
            
        default:
            break;
            
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async(execute: {
            if let receivedMessage = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
                self.performSegue(withIdentifier: "proceedToGame", sender: self)

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
