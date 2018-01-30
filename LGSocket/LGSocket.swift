
public protocol LGSocketDelegate: NSObjectProtocol {
    func lgSocket(_ socket: LGSocket, handle message: LGMessage, type: LGMessageType)
}

public enum LGMessageType : Int {
    case enterRoom = 0
    case leaveRoom = 1
    case chatMessage = 2
    case giftMessage = 3
}

public class LGSocket {
    
    public weak var delegate : LGSocketDelegate?
    
    private lazy var tcpClient : TCPClient = TCPClient(addr: self.addr, port :2828)
    private var addr: String
    public init(addr a: String) {
        addr = a
    }
}


// MARK:- 和服务器建立连接
extension LGSocket {
    public func connect() -> Bool {
        let sucsess = tcpClient.connect(timeout: 5).0
        if sucsess {
            sendMessage(type: .enterRoom, msg: LGMessage())
        }
        return sucsess
    }
    
    public func disconnect() {
        tcpClient.close()
    }
    
    public func startReadMsg() {
        DispatchQueue.global().async {
            while true {
                if let lengthByte = self.tcpClient.read(4) {
                    // 1.获取数据的长度
                    let lengthData = NSData(bytes: lengthByte, length: 4)
                    var length : Int = 0
                    lengthData.getBytes(&length, length: 4)
                    
                    // 2.读取消息的类型
                    guard let typeBytes = self.tcpClient.read(2) else {
                        self.tcpClient.read(length)
                        continue
                    }
                    let typeData = NSData(bytes: typeBytes, length: 2)
                    var type : Int = 0
                    typeData.getBytes(&type, length: 2)
                    
                    // 3.获取具体的内容
                    guard let dataBytes = self.tcpClient.read(length) else {
                        return
                    }
                    let msgData = Data(bytes: dataBytes, count: length)
                    
                    // 4.处理消息
                    DispatchQueue.main.async {
                        self.handleMsg(LGMessageType(rawValue: type)!, msgData: msgData)
                    }
                }
            }
        }
    }
}


// MARK:- 处理消息
extension LGSocket {
    private func handleMsg(_ type: LGMessageType ,msgData : Data) {
        let msg = try! LGMessage(serializedData: msgData)
        delegate?.lgSocket(self, handle: msg, type: type)
    }
}


// MARK:- 发送消息方法
extension LGSocket {
    
    @discardableResult
    public func sendMessage(type : LGMessageType, msg: LGMessage) -> (Bool, String) {
        
        // 1.获取消息的长度
        let msgData = try! msg.serializedData()
        var length = msgData.count
        let lengthData = Data(bytes: &length, count: 4)
        
        // 2.获取消息的类型
        var tempType = type.rawValue
        let typeData = Data(bytes: &tempType, count: 2)
        
        // 3.将message转成Data类型
        return tcpClient.send(data: lengthData + typeData + msgData)
    }
    
}

extension LGSocket {
    //MARK: - 获取IP
    public static func getIPAddresses() -> String? {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }

}
