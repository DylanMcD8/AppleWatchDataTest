//
//  InterfaceController.swift
//  SendToWatchTest WatchKit Extension
//
//  Created by Dylan McDonald on 2/8/21.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var messageLabel: WKInterfaceLabel!
    
//    override func awake(withContext context: Any?) {
//        // Configure interface objects here.
//    }
//
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
//        if WCSession.isSupported() {
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//        }
        messageLabel.setText("Last message received: \(UserDefaults.standard.object(forKey: "ScheduleDays") ?? "No message")")
        NotificationCenter.default.addObserver(self, selector: #selector(MessageReceived), name: NSNotification.Name(rawValue: "MessageReceived"), object: nil)
    }
    
    @objc func MessageReceived(_ notification: Notification) {
        messageLabel.setText("\(UserDefaults.standard.object(forKey: "ScheduleDays") ?? "No message")")
        WKInterfaceDevice().play(.click)
    }

//    override func didDeactivate() {
//        // This method is called when watch view controller is no longer visible
//    }
//
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        WKInterfaceDevice().play(.click)
//        messageLabel.setText("Message Received!")
////        messageLabel.setText(message)
//    }
//
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//
//    }
    
}
