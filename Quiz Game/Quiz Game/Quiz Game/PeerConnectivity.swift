//
//  PeerConnectivity.swift
//  Quiz Game
//
//  Created by Curtis Jackson on 4/23/17.
//  Copyright © 2017 491 A5. All rights reserved.
//
/*
import UIKit
import MultipeerConnectivity

class PeerConnectivity: NSObject, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    let serviceType = "Quiz-Game"
    var session: MCSession!
    var peerID: MCPeerID!
    var serviceBrowser: MCBrowserViewController!
    var advertisingAssistant: MCAdvertiserAssistant!
    var players: [String] = []
    
    override init() {
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.serviceBrowser = MCBrowserViewController(serviceType: serviceType, session: session)
        self.advertisingAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
        
        super.init()
        
        advertisingAssistant.start()
        session.delegate = self
        serviceBrowser.delegate = self
        
        players.append(peerID.displayName)
        
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
                serviceBrowser.present(tooManyPlayers, animated: true, completion: nil)
                
            }
            
            print("Total players from PeerConnectivity Class:")
            print(players)
            
        case .notConnected:
            players.remove(at: index(ofAccessibilityElement: peerID))
            
            print(players)
            
        default:
            break;
            
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        
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
    
}
*/
