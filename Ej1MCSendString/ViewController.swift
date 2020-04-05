//
//  ViewController.swift
//  Ej1MCSendString
//
//  Created by lucas on 30/03/2019.
//  Copyright © 2019 lucas. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    


    @IBOutlet weak var textToSend: UITextField!
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var textRecievedLabel: UILabel!
    
    @IBOutlet weak var listaPeers: UITableView!
    let sendTextService = SendTextService()
    
    var listaUsuarios : [String] = []

    @IBOutlet weak var list: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.listaUsuarios = [String]()
        sendTextService.delegate=self
        self.list.text = ""

    }

    @IBAction func sendText(_ sender: Any) {
        let text = self.textToSend.text ?? "Texto vacío"
        sendTextService.send(text: text)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.listaUsuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiCelda", for: indexPath)
        cell.detailTextLabel?.text = self.listaUsuarios[indexPath.row]
        return cell
    }
    
}


extension ViewController: SendTextServiceDelegate {
    
    func connectedDevicesChanged(manager: SendTextService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "\(connectedDevices)"
        }
    }
    
    func sendTextService(didReceive text: String) {
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        
        let synthesizer = AVSpeechSynthesizer()
        
        OperationQueue.main.addOperation {
            synthesizer.speak(utterance)
            self.textRecievedLabel.text = text
        }
    }
    
}



