//
//  ControlViewController.swift
//  NeverGoneBot-iOS
//
//  Created by Aadesh Patel on 2/7/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit
import AVFoundation

class ControlViewController: UIViewController {
    var room: String = ""
    
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    @IBOutlet weak var localView: RTCEAGLVideoView!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var joystickView: JoystickView!
    
    private var remoteVideoTrack: RTCVideoTrack!
    private var localVideoTrack: RTCVideoTrack!
    
    private var remoteVideoSize: CGSize!
    private var localVideoSize: CGSize!
    
    private var isMute: Bool = false
    private var isVideoBack: Bool = false
    
    private var client: ARDAppClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.remoteView.delegate = self
        self.localView.delegate = self
        
        self.localView.layer.masksToBounds = true
        self.localView.layer.cornerRadius = 10.0
        
        self.view.bringSubviewToFront(self.localView)
        self.view.bringSubviewToFront(self.endCallButton)
        self.view.bringSubviewToFront(self.audioButton)
        self.view.bringSubviewToFront(self.videoButton)
        self.view.bringSubviewToFront(self.joystickView)
        
        self.joystickView.layer.masksToBounds = true
        self.joystickView.layer.cornerRadius = self.joystickView.frame.size.width / 2.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.disconnect()
        self.client = ARDAppClient(delegate: self)
        self.client.serverHostUrl = "https://apprtc.appspot.com"
        self.client.connectToRoomWithId(/*self.room*/"myro-000002", options: nil)
        self.client.muteAudioIn()
        
        //SocketService.Socket = SocketIOClient(socketURL: NSURL(string: SocketService.URL)!, options: [.Log(true), .ForcePolling(true), .ConnectParams(["token": User.connectedRobotToken])])
        //SocketService.connect()        
    }
    
    deinit {
        self.disconnect()
        SocketService.disconnect()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.disconnect()
        SocketService.disconnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toggleAudio(sender: UIButton) {
        self.isMute ? self.client.unmuteAudioIn() : self.client.muteAudioIn()
        self.isMute = !self.isMute
    }
    
    @IBAction func toggleVideo() {
        self.isVideoBack ? self.client.swapCameraToFront() : self.client.swapCameraToBack()
        self.isVideoBack = !self.isVideoBack
    }
    
    @IBAction func endCall() {
        self.disconnect()
        SocketService.disconnect()

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func disconnect() {
        guard self.client != nil else { return }
        
        if (self.remoteVideoTrack != nil) {
            self.remoteVideoTrack.removeRenderer(self.remoteView)
        }
        
        if (self.localVideoTrack != nil) {
            self.localVideoTrack.removeRenderer(self.localView)
        }

        self.remoteVideoTrack = nil
        self.localVideoTrack = nil
        
        self.client.disconnect()
    }
    
    private func remoteDisconnected() {
        if (self.remoteVideoTrack != nil) {
            self.remoteVideoTrack.removeRenderer(self.remoteView)
        }
        
        self.remoteVideoTrack = nil
        self.videoView(self.localView, didChangeVideoSize: self.localVideoSize)
    }
    
    @IBAction func joystickMoved(sender: JoystickView) {
        SocketService.publish("myro-instruction", items: "DATA HERE")
        
    }
}

extension ControlViewController: ARDAppClientDelegate {
    func appClient(client: ARDAppClient!, didChangeState state: ARDAppClientState) {
        switch(state) {
        case ARDAppClientState.Connected:
            print("Connected")
            break
            
        case ARDAppClientState.Connecting:
            print("Connecting")
            break
        
        case ARDAppClientState.Disconnected:
            print("Disconnected")
            self.remoteDisconnected()
            break
        }
    }
    
    func appClient(client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        self.remoteVideoTrack = remoteVideoTrack
        self.remoteVideoTrack.addRenderer(self.remoteView)
        
        UIView.animateWithDuration(0.5) {
            let orientation = UIDevice.currentDevice().orientation
            let width = self.view.frame.size.width / 4.0
            let height = self.view.frame.size.height / 4.0
            
            var videoRect = CGRectMake(self.localView.frame.origin.x, self.localView.frame.origin.y, width, height)
            if (orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight) {
                videoRect = CGRectMake(self.localView.frame.origin.x, self.localView.frame.origin.y, height, width)
            }
            
            let videoFrame = AVMakeRectWithAspectRatioInsideRect(self.localView.frame.size, videoRect)
            //self.localView.frame = videoFrame
            //self.localView.layer.cornerRadius = self.localView.frame.size.width / 2.0
        }
    }
    
    func appClient(client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        if (self.localVideoTrack != nil) {
            self.localVideoTrack.removeRenderer(self.localView)
            self.localVideoTrack = nil
        }
        
        self.localVideoTrack = localVideoTrack
        self.localVideoTrack.addRenderer(self.localView)
    }
    
    func appClient(client: ARDAppClient!, didError error: NSError!) {
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        self.disconnect()
    }
}

extension ControlViewController: RTCEAGLVideoViewDelegate {
    func videoView(videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        let orientation = UIDevice.currentDevice().orientation
        UIView.animateWithDuration(0.5) {
            let width = self.view.frame.size.width / 4.0
            let height = self.view.frame.size.height / 4.0
            
            let defaultRatio = CGSizeMake(4.0, 3.0)
            
            if (videoView == self.remoteView) {
                self.remoteVideoSize = size
                let ratio = CGSizeEqualToSize(size, CGSizeZero) ? defaultRatio : size
                let videoRect = self.view.bounds
                
                let videoFrame = AVMakeRectWithAspectRatioInsideRect(ratio, videoRect)
                self.remoteView.frame = videoFrame
            } else if (videoView == self.localView) {
                self.localVideoSize = size
                let ratio = CGSizeEqualToSize(size, CGSizeZero) ? defaultRatio : size
                var videoRect = self.view.bounds

                if (self.remoteVideoTrack != nil) {
                    videoRect = CGRectMake(self.localView.frame.origin.x, self.localView.frame.origin.y, width, height)
                    
                    if (orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight) {
                        videoRect = CGRectMake(self.localView.frame.origin.x, self.localView.frame.origin.y, height, width)
                    }
                }
                
                let videoFrame = AVMakeRectWithAspectRatioInsideRect(ratio, videoRect);
               //self.localView.frame = videoFrame
               // self.localView.layer.cornerRadius = self.localView.frame.size.width / 2.0
            }
        }
    }
}
