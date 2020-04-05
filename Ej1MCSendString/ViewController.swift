//
//  ViewController.swift
//  Ej1MCSendString
//
//  Created by lucas on 30/03/2019.
//  Copyright © 2019 lucas. All rights reserved.
//

import UIKit
import AVFoundation
import MultipeerConnectivity

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    


    @IBOutlet weak var textToSend: UITextField!
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var textRecievedLabel: UILabel!
    
    @IBOutlet weak var listaPeers: UITableView!
    let sendTextService = SendTextService()
    
    var listaUsuarios : [String] = []
    var listaPeersIDs : [MCPeerID] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.listaUsuarios = [String]()
        sendTextService.delegate=self
        
        self.listaPeers.delegate = self
        self.listaPeers.dataSource = self

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
        cell.textLabel?.text = self.listaUsuarios[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = indexPath.row
        let selectedPeer = self.listaUsuarios[selectedRow]
        
        let alert = UIAlertController(title: "Nueva conexión", message: "¿Conectar con " + selectedPeer + "?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Conectar", comment: "Default action"), style: .default, handler: { _ in
            self.sendTextService.invite(displayName: selectedPeer)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
        self.listaPeers.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    
}


extension ViewController: SendTextServiceDelegate {
    
    func devicesNear(devices: [MCPeerID]) {
        OperationQueue.main.addOperation {
            self.listaUsuarios = devices.map({$0.displayName})
            self.listaPeersIDs = devices
            self.listaPeers.reloadData()
        }
    }
    
    
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



