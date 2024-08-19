//
//  RtpSocketTcp.swift
//  app
//
//  Created by Pedro on 10/09/2020.
//  Copyright © 2020 pedroSG94. All rights reserved.
//

import Foundation

public class RtpSocketTcp: BaseRtpSocket {

    private var header = Array<UInt8>(arrayLiteral: 36, 0x00, 0x00, 0x00)
    private let socket: Socket
    
    init(socket: Socket) {
        self.socket = socket
    }
    
    public override func sendFrame(rtpFrame: RtpFrame) throws {
        var buffer = rtpFrame.buffer
        header[1] = UInt8(2 * rtpFrame.channelIdentifier)
        header[2] = UInt8(rtpFrame.length >> 8)
        header[3] = UInt8(rtpFrame.length & 0xFF)
        buffer.insert(contentsOf: header, at: 0)
        
        try socket.write(buffer: buffer)
    }
    
    public override func flush() {
        socket.flush()
    }
}
