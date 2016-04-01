//
//  RobotViewController.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/1/16.
//  Copyright © 2016 ISBX. All rights reserved.
//

import UIKit
import AVFoundation

class RobotViewController: UIViewController {
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    private var remoteVideoTrack: RTCVideoTrack!
    private var remoteVideoSize: CGSize!
    
    private var isMute: Bool = false
    private var isVideoBack: Bool = false
    
    private var client: ARDAppClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.remoteView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.client = ARDAppClient(delegate: self)
        self.client.serverHostUrl = "https://apprtc.appspot.com"
        self.handleRobotUdidIfNeeded({ (response: [String : AnyObject]) in
                self.client.connectToRoomWithId("myro-\(Robot.currentRobot.code)", options: nil)
            },
            failure: { (error: NSError) in
                // TODO: Handle Error
        })
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.disconnect()
        
        SocketService.connect()
        SocketService.subscribe("myro-instruction-\(Robot.currentRobot.udid)", callback: { (response: [AnyObject], emitter: SocketAckEmitter) in
            guard let str = response as? String, let data = str.dataUsingEncoding(NSUTF8StringEncoding) else { return }
            
            BLEManager.sharedManager.sendData(data)
        })
        
        //self.client = ARDAppClient(delegate: self)
        //self.client.connectToRoomWithId("myro-test10", options: nil)
        //self.client.muteAudioIn()
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
    
    private func handleRobotUdidIfNeeded(success: APISuccessBlock, failure: APIFailureBlock) {
        guard Robot.currentRobot == nil else {
            success?([:])
            return
        }
        
        guard let uuid = UIDevice.currentDevice().identifierForVendor?.UUIDString else { return }
        
        let robot = Robot()
        robot.name = "Robot Name"
        robot.udid = uuid
        RobotService.createRobot(robot,
            success: { (response: [String : AnyObject]) in
                Robot.currentRobot = Robot.fromJSON(response)
                success?(response)
            },
            failure: failure)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func disconnect() {
        guard self.client != nil else { return }
        
        if (self.remoteVideoTrack != nil) {
            self.remoteVideoTrack.removeRenderer(self.remoteView)
        }
        
        self.remoteVideoTrack = nil
        
        self.client.disconnect()
    }
    
    private func remoteDisconnected() {
        if (self.remoteVideoTrack != nil) {
            self.remoteVideoTrack.removeRenderer(self.remoteView)
        }
        
        self.remoteVideoTrack = nil
    }
}

extension RobotViewController: ARDAppClientDelegate {
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
    }
    
    func appClient(client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        
    }
    
    func appClient(client: ARDAppClient!, didError error: NSError!) {
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        self.disconnect()
    }
}

extension RobotViewController: RTCEAGLVideoViewDelegate {
    func videoView(videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        UIView.animateWithDuration(0.5) {
            let defaultRatio = CGSizeMake(4.0, 3.0)
            
            if (videoView == self.remoteView) {
                self.remoteVideoSize = size
                let ratio = CGSizeEqualToSize(size, CGSizeZero) ? defaultRatio : size
                let videoRect = self.view.bounds
                
                let videoFrame = AVMakeRectWithAspectRatioInsideRect(ratio, videoRect)
                self.remoteView.frame = videoFrame
            }
        }
    }
}

