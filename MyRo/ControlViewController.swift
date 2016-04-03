//
//  ControlViewController.swift
//  MyRo-iOS
//
//  Created by Aadesh Patel on 2/7/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit
import AVFoundation

/// View controller where all the interaction between a user and robot occurs
class ControlViewController: UIViewController {
    /// WebRTC room the user should join for video communication
    var room: String = ""
    
    /// BLEManager instance for this specific view controller
    private var manager: BLEManager!
    
    /// Robot's video stream view
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    
    /// Current user's video stream view
    @IBOutlet weak var localView: RTCEAGLVideoView!
    
    /// Button to toggle audio on/off
    @IBOutlet weak var audioButton: UIButton!
    
    /// Button to toggle video between front and back camera
    @IBOutlet weak var videoButton: UIButton!
    
    /// Button to leave the current video call room
    @IBOutlet weak var endCallButton: UIButton!
    
    /// Joystick view to control robot movements
    @IBOutlet weak var joystickView: JoystickView!
    
    /// Slider to control robot's speed
    @IBOutlet weak var speedSlider: UISlider!
    
    /// Robot's video stream object
    private var remoteVideoTrack: RTCVideoTrack!
    
    /// User's video stream object
    private var localVideoTrack: RTCVideoTrack!
    
    /// Robot's video stream view size
    private var remoteVideoSize: CGSize!
    
    /// User's video stream view size
    private var localVideoSize: CGSize!
    
    /// If audio is currently on or off
    private var isMute: Bool = false
    
    /// If user's video stream is from back camera or not
    private var isVideoBack: Bool = false
    
    /// WebRTC client object
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
        //self.view.bringSubviewToFront(self.joystickView)
        
        //self.joystickView.layer.masksToBounds = true
        //self.joystickView.layer.cornerRadius = self.joystickView.frame.size.width / 2.0
        
        print("MANAGER")
        self.manager = BLEManager()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.disconnect()
        self.client = ARDAppClient(delegate: self)
        self.client.serverHostUrl = "https://apprtc.appspot.com"
        self.client.connectToRoomWithId(self.room, options: nil)
        //self.client.muteAudioIn()
        
        //SocketService.Socket = SocketIOClient(socketURL: NSURL(string: SocketService.URL)!, options: [.Log(true), .ForcePolling(true), .ConnectParams(["token": User.connectedRobotToken])])
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
    
    /**
     Toggles the user's audio for the video stream
     
     - parameter sender: UIButton that invoked this selector
     */
    @IBAction func toggleAudio(sender: UIButton) {
        //self.isMute ? self.client.unmuteAudioIn() : self.client.muteAudioIn()
        self.isMute = !self.isMute
    }
    
    /**
     Toggles user's video stream between front and back camera
     */
    @IBAction func toggleVideo() {
        //self.isVideoBack ? self.client.swapCameraToFront() : self.client.swapCameraToBack()
        self.isVideoBack = !self.isVideoBack
    }
    
    /**
     Wrapper function that invokes methods to disconnect the user from the websocket
     and the video call room
     */
    @IBAction func endCall() {
        self.disconnect()
        SocketService.disconnect()

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     Disconnects the user from the video call room
     */
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
    
    /**
     Handles the event when the robot disconnects from the video call room
     */
    private func remoteDisconnected() {
        if (self.remoteVideoTrack != nil) {
            self.remoteVideoTrack.removeRenderer(self.remoteView)
        }
        
        self.remoteVideoTrack = nil
        self.videoView(self.localView, didChangeVideoSize: self.localVideoSize)
    }
    
    /**
     Sends data to the robot app via websocket when the user wants to move the robot
     
     - parameter sender: JoystickView that invoked this selector
     */
    @IBAction func joystickMoved(sender: JoystickView) {
        SocketService.publish("myro-instruction", items: "DATA HERE")
    }
    
    /*@IBAction func onePressed() {
        self.manager.sendData(NSData(bytes: [self.speedSlider.value > 0.0 ? "H" : "L"] as [Character], length: 1))
        self.manager.sendData(NSData(bytes: [9] as [UInt8], length: 1))
        self.manager.sendData(NSData(bytes: [Int(self.speedSlider.value)] as [Int], length: 1))
    }*/
    
    /// Sends data to the robot to move forward
    @IBAction func upPressed() {
        self.manager.sendData(NSData(bytes: [self.speedSlider.value > 0.0 ? "H" : "L"] as [Character], length: 1))
        self.manager.sendData(NSData(bytes: [11] as [UInt8], length: 1))
        self.manager.sendData(NSData(bytes: [Int(self.speedSlider.value)] as [Int], length: 1))
    }
    
    /// Sends data to the robot to move backwards
    @IBAction func downPressed() {
        self.manager.sendData(NSData(bytes: [self.speedSlider.value > 0.0 ? "H" : "L"] as [Character], length: 1))
        self.manager.sendData(NSData(bytes: [13] as [UInt8], length: 1))
        self.manager.sendData(NSData(bytes: [Int(self.speedSlider.value)] as [Int], length: 1))
    }
    
    /*
    @IBAction func fourPressed() {
        self.manager.sendData(NSData(bytes: [self.speedSlider.value > 0.0 ? "H" : "L"] as [Character], length: 1))
        self.manager.sendData(NSData(bytes: [7] as [UInt8], length: 1))
        self.manager.sendData(NSData(bytes: [Int(self.speedSlider.value)] as [Int], length: 1))
    }*/
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
