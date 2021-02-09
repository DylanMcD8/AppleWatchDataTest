//
//  ViewController.swift
//  SendToWatchTest
//
//  Created by Dylan McDonald on 2/8/21.
//

import UIKit
import Communicator
import SPAlert

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var sendToWatchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldView.layer.cornerRadius = 20
        fieldView.layer.cornerCurve = .continuous
        
        sendToWatchButton.layer.cornerRadius = 20
        sendToWatchButton.layer.cornerCurve = .continuous
        
        fieldView.layer.borderWidth = 2
        fieldView.layer.borderColor = UIColor.systemFill.cgColor
        
        sendToWatchButton.layer.borderWidth = 2
        sendToWatchButton.layer.borderColor = UIColor.systemFill.cgColor
        
        mainTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mainTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func sendToWatch(_ sender: Any) {
//        let data = ["Class 1", "Class 2", "Class 3", "Class 4", "Class 5", "Class 6", "Class 7", "Class 8"]
        let content: Content = ["NewDataSync" : mainTextField.text ?? "Error"]
//        let content: Content = ["NewDataSync" : data]
        let message = ImmediateMessage(identifier: "ScheduleClasses", content: content)
        Communicator.shared.send(message) { error in
//            switch result {
//            case . (let error):
//                DispatchQueue.main.async {
//                    SPAlert.present(title: "Error. See Logs.", preset: .error, haptic: .error)
//                }
            print("Error sending immediate message", error)
//            case .success:
//                DispatchQueue.main.async {
            SPAlert.present(title: "Error: \(error)".replacingOccurrences(of: "sessionIsNotReachable(minimumReachability: Communicator.Reachability.immediatelyReachable, actual: Communicator.Reachability.backgroundOnly)", with: "Apple Watch Unreachable"), preset: .error, haptic: .error)
//                }
            }
        }
//        let message = ImmediateMessage(identifier: "message", content: ["hello": "world"])
//        Communicator.shared.send(message) { error in
//            print("Error sending immediate message", error)
//        }
//    }
    
    @IBAction func sendMessageTapped() {
        let message = ImmediateMessage(identifier: "message", content: ["hello": "world"])
        Communicator.shared.send(message) { error in
            print("Error sending immediate message", error)
        }
    }
    
    @IBAction func sendInteractiveMessageTapped() {
        let message = InteractiveImmediateMessage(identifier: "interactive_message", content: ["hello": "world"]) { reply in
            print("Received reply from message: \(reply)")
        }
        Communicator.shared.send(message) { error in
            print("Error sending immediate message", error)
        }
    }
    
    @IBAction func sendGuaranteedMessageTapped() {
        let message = GuaranteedMessage(identifier: "guaranteed_message", content: ["hello": "world"])
        Communicator.shared.send(message) { result in
           switch result {
                case .failure(let error):
                    print("Error transferring blob: \(error.localizedDescription)")
                case .success:
                    print("Successfully transferred guaranteed message to watch")
            }
        }
    }
    
    @IBAction func transferBlobTapped() {
        let data = Data("hello world".utf8)
        let blob = Blob(identifier: "blob", content: data)
        let task = Communicator.shared.transfer(blob) { result in
            switch result {
                case .failure(let error):
                    print("Error transferring blob: \(error.localizedDescription)")
                case .success:
                    print("Successfully transferred blob to watch")
            }
        }
        task?.cancel()
    }
    
    @IBAction func syncContextTapped() {
        let context = Context(content: ["hello" : "world"])
        do {
            try Communicator.shared.sync(context)
            print("Synced context to watch")
        } catch let error {
            print("Error syncing context to watch: \(error.localizedDescription)")
        }
    }
    
    @IBAction func transferComplicationInfoTapped() {
        switch Communicator.shared.currentWatchState {
            case .notPaired:
                print("Watch is not paired, cannot transfer complication info")
            case .paired(let appState):
                switch appState {
                    case .notInstalled:
                        print("App is not installed, cannot transfer complication info")
                    case .installed(let compState, _):
                        switch compState {
                            case .notEnabled:
                                print("Complication is not enabled on the active watch face, cannot transfer complication info")
                            case .enabled(let numberOfComplicationUpdatesAvailable):
                                print("Number of complication transfers available today (usually out of 50)", numberOfComplicationUpdatesAvailable)
                                transferCompInfo()
                    }
            }
        }
    }
    
    private func transferCompInfo() {
        let complicationInfo = ComplicationInfo(content: ["Value" : 1])
        Communicator.shared.transfer(complicationInfo) { result in
            switch result {
                case .success(let numberOfComplicationUpdatesAvailable):
                    print("Successfully transferred complication info, number of complications now available: ", numberOfComplicationUpdatesAvailable)
                case .failure(let error):
                    print("Failed to transfer complication info", error.localizedDescription)
            }
            
        }
    }
    
  
    
}

