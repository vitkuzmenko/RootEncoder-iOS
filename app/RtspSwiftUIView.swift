//
//  RtspSwiftUIView.swift
//  app
//
//  Created by Pedro  on 20/9/23.
//  Copyright © 2023 pedroSG94. All rights reserved.
//

import SwiftUI

struct RtspSwiftUIView: View, ConnectCheckerRtsp {
    
    func onConnectionSuccessRtsp() {
        print("connection success")
        toastText = "connection success"
        isShowingToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isShowingToast = false
        }
    }
    
    func onConnectionFailedRtsp(reason: String) {
        print("connection failed: \(reason)")
        rtspCamera.stopStream()
        bStreamText = "Start stream"
        toastText = "connection failed: \(reason)"
        isShowingToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isShowingToast = false
        }
    }
    
    func onNewBitrateRtsp(bitrate: UInt64) {
        print("new bitrate: \(bitrate)")
    }
    
    func onDisconnectRtsp() {
        print("disconnected")
        toastText = "disconnected"
        isShowingToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isShowingToast = false
        }
    }
    
    func onAuthErrorRtsp() {
        print("auth error")
        toastText = "auth error"
        isShowingToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isShowingToast = false
        }
    }
    
    func onAuthSuccessRtsp() {
        print("auth success")
        toastText = "auth success"
        isShowingToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isShowingToast = false
        }
    }
    
    
    @State private var endpoint = "rtsp://192.168.0.177:8554/live/pedro"
    @State private var bStreamText = "Start stream"
    @State private var isShowingToast = false
    @State private var toastText = ""
    @State private var rtspCamera: RtspCamera!
    
    var body: some View {
        ZStack {
            let camera = CameraUIView()
            let cameraView = camera.view
            camera.edgesIgnoringSafeArea(.all)
            
            camera.onAppear {
                rtspCamera = RtspCamera(view: cameraView, connectChecker: self)
                //rtspCamera.setCodec(codec: CodecUtil.H265)
                rtspCamera.startPreview()
            }
            camera.onDisappear {
                if (rtspCamera.isStreaming()) {
                    rtspCamera.stopStream()
                }
                if (rtspCamera.isOnPreview()) {
                    rtspCamera.stopPreview()
                }
            }
            
            VStack {
                TextField("rtsp://ip:port/app/streamname", text: $endpoint)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .padding(.top, 24)
                    .padding(.horizontal)
                    .keyboardType(.default)
                
                Spacer()
                HStack(alignment: .center, spacing: 16, content: {
                    Button(bStreamText) {
                        let endpoint = endpoint
                        if (!rtspCamera.isStreaming()) {
                            if (rtspCamera.prepareAudio() && rtspCamera.prepareVideo()) {
                                rtspCamera.startStream(endpoint: endpoint)
                                bStreamText = "Stop stream"
                            }
                        } else {
                            rtspCamera.stopStream()
                            bStreamText = "Start stream"
                        }
                    }
                    Button("Switch camera") {
                        rtspCamera.switchCamera()
                    }
                }).padding(.bottom, 24)
            }.frame(width: .infinity, height: .infinity, alignment: .bottom)
        }.showToast(text: toastText, isShowing: $isShowingToast)
    }
}

#Preview {
    RtspSwiftUIView()
}