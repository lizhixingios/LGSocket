//
//  IMServerManager.swift
//  IMServer
//
//  Created by 掎角之势 on 2018/1/25.
//  Copyright © 2018年 刚抓住了几只妖. All rights reserved.
//

open class LGServerManager {

    private lazy var tcpServer = TCPServer(addr: "0.0.0.0", port: 2828)
    
    private lazy var clients = [LGClient]()
    
    private var fire = true
    
    public init() {
        
    }
}

extension LGServerManager {
    open func startRunning() -> Bool {
        // 1.监听客户端的链接
        let isSucsess = tcpServer.listen().0
        
        // 2.接受客户端的链接
        DispatchQueue.global().async {
            while self.fire {
                if let tcpClient = self.tcpServer.accept() {
                    DispatchQueue.global().async {
                        self.handleClient(tcpClient)
                    }
                }
            }
        }
        return isSucsess
    }
    
    open func stopRunning() {
        self.fire = false
    }
}

extension LGServerManager {
    private func handleClient(_ client : TCPClient) {
        let client = LGClient(client: client)
        clients.append(client)
        
        client.callback = {[unowned self] (isLeave, data, client) in
            // 1.是否需要移动客户端
            if isLeave {
                if let index = self.clients.index(of: client) {
                    self.clients.remove(at: index)
                    client.tcpClient.close()
                }
            }
            
            // 2.将消息转发出去
            for c in self.clients {
                c.tcpClient.send(data: data)
            }
        }
        
        client.removeClientCallback = {[unowned self] (client) in
            if let index = self.clients.index(of: client) {
                self.clients.remove(at: index)
                client.tcpClient.close()
            }
        }
        
        client.startReadMessage()
    }
}
