//
//  ViewController.swift
//  LGSocket
//
//  Created by lizhixingios on 01/30/2018.
//  Copyright (c) 2018 lizhixingios. All rights reserved.
//

import UIKit
import LGSocket
class ViewController: UIViewController, LGSocketDelegate {

    let server = LGServerManager()
    
    lazy var socket = LGSocket(addr: "192.168.6.30")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let running = server.startRunning()
        let connect = socket.connect()
        
        if running, connect {
            socket.delegate = self
            socket.startReadMsg()
        }
        print(running,connect,LGSocket.getIPAddresses()!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var msg = LGMessage()
        msg.level = 100
        msg.iconURL = "sss"
        msg.userID = 100
        msg.userName = "大神~"
        msg.message = "你好~"
        let type = LGMessageType.chatMessage
        print(type)
        print(socket.sendMessage(type: type, msg: msg))
    }

    func lgSocket(_ socket: LGSocket, handle message: LGMessage, type: LGMessageType) {
        print(type,message.userName)
    }

}

