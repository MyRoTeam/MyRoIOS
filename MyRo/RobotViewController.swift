//
//  RobotViewController.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

import UIKit
import AVFoundation

/**
 View controller that handles the WebRTC video stream communication and displays the
 client's video stream
 */
class RobotViewController: UIViewController {
    /// Button to leave the current video call room
    @IBOutlet weak var endButton: UIButton!
    
    /// Connected user's video stream view
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    
    /// Connected user's video stream
    private var remoteVideoTrack: RTCVideoTrack!
    
    /// Connected user's video stream view size
    private var remoteVideoSize: CGSize!
    
    /// If audio is currently on or off
    private var isMute: Bool = false
    
    //private var isVideoBack: Bool = false
    
    /// WebRTC client object
    private var client: ARDAppClient!
    
    /// Bluetooth Manager
    private let manager = BLEManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DataService.dataService.INS_REF.removeValue()
        MqttManager.sharedManager = MqttManager(subscriptions: ["myro/instruction"])
        MqttManager.sharedManager.connect()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(didReceiveInstruction(_:)),
            name: MqttManager.NotificationKey.MQTTDidReceiveNotification,
            object: nil)
        
        self.remoteView.delegate = self
        
        self.view.bringSubviewToFront(self.endButton)
        
        self.client = ARDAppClient(delegate: self)
        self.client.serverHostUrl = "https://apprtc.appspot.com"
        self.client.connectToRoomWithId("my-ro-asdf-11", options: nil)
        
        
        /*DataService.dataService.INS_REF.observeEventType(.ChildRemoved, withBlock: { snapshot in
            print("OBSERVE: \(snapshot.value)")
            
            guard let instruction = snapshot.value as? String else { return }
            guard let data = instruction.dataUsingEncoding(NSUTF8StringEncoding) else { return }
            self.manager.sendData(data)
            
            /*if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    guard let instruction = snap.value as? String else { continue }
                    print("instruction: \(instruction)")
                    
                    guard let data = instruction.dataUsingEncoding(NSUTF8StringEncoding) else { return }
                    self.manager.sendData(data)
                    
                    /*if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let instruction = Instruction(key: key, dictionary: postDictionary)
                    }*/
                }
            }*/
        })*/
    }
    
    @IBAction func didReceiveInstruction(notif: NSNotification) {
        guard let instruction = notif.object as? String else { return }
        
        print("INSTRUC: \(instruction)")
        
        self.manager.sendData(NSData(bytes: ["X"] as [Character], length: 1))
        self.manager.sendData(NSData(bytes: ["F"] as [Character], length: 1))
        self.manager.sendData(NSData(bytes: ["Y"] as [Character], length: 1))
        self.manager.sendData(NSData(bytes: [255] as [UInt8], length: 1))
        //guard let data = NSData(bytes: instruction, length: 4) else { return }
        guard let data = instruction.dataUsingEncoding(NSUTF8StringEncoding) else { return }
        self.manager.sendData(data)
        /*do {
            guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : AnyObject] else { return }
            
            print("DIR: \(json["dir" as! String])")
            self.manager.sendData(NSData(bytes: ["X"] as [Character], length: 1))
            self.manager.sendData(NSData(bytes: [json["dir"] as! String as! Character] as [Character], length: 1))
            self.manager.sendData(NSData(bytes: ["Y"] as [Character], length: 1))
            self.manager.sendData(NSData(bytes: [json["speed"] as! UInt8] as [UInt8], length: 1))
            
            //self.manager.sendData(data)
        } catch {}*/
    }

    //private var manager: BLEManager!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /*self.handleRobotUdidIfNeeded({ (response: [String : AnyObject]) in
                print("Connecting To: \(Robot.currentRobot.code)")
                self.client.connectToRoomWithId("myro-code123", options: nil)
            },
            failure: { (error: NSError) in
                // TODO: Handle Error
        })*/
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        /*SocketService.connect()
        SocketService.subscribe("myro instruction", callback: { (response: [AnyObject], emitter: SocketAckEmitter) in
            print("RECEIVED: \(response)")
            guard let str = response as? String, let data = str.dataUsingEncoding(NSUTF8StringEncoding) else { return }
            
            //BLEManager.sharedManager.sendData(data)
        })*/
        
        
        //self.manager = BLEManager()
        
        //self.client = ARDAppClient(delegate: self)
        //self.client.connectToRoomWithId("myro-test10", options: nil)
        //self.client.muteAudioIn()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        //self.disconnect()
        //SocketService.disconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        //self.disconnect()
        //SocketService.disconnect()
    }
    
    /**
     Retrieves UDID from the current device, sends it to the server to map the current device to
     the supplied UDID, and then caches the UDID for the device in the device's Keychain which is
     a persistent and secure cache on iOS devices. If the UDID already exists in the Keychain cache,
     then it won't send a request to the server.
     
     - parameter success: Callback that gets invoked if the server successfully saves the UDID supplied
     - parameter failure: Callback that gets invoked if the server fails to save the UDID supplied
    */
    private func handleRobotUdidIfNeeded(success: APISuccessBlock, failure: APIFailureBlock) {
        guard Robot.currentRobot == nil else {
            success?([:])
            return
        }
        
        guard let uuid = UIDevice.currentDevice().identifierForVendor?.UUIDString else { return }
        
        let robot = Robot()
        robot.name = "Robot Name"
        robot.udid = uuid
        RobotService.createRobot(robot).then { robot in
            Robot.currentRobot = robot
        }
    }
    
    /**
     Toggles the robot's audio for the video stream
     
     - parameter sender: UIButton that invoked this selector
     */
    @IBAction func toggleAudio(sender: UIButton) {
        //self.isMute ? self.client.unmuteAudioIn() : self.client.muteAudioIn()
        self.isMute = !self.isMute
    }
    
    /*
    @IBAction func toggleVideo() {
        self.isVideoBack ? self.client.swapCameraToFront() : self.client.swapCameraToBack()
        self.isVideoBack = !self.isVideoBack
    }*/
    
    /**
     Wrapper function that invokes methods to disconnect the robot from the websocket
     and the video call room
     */
    @IBAction func endCall() {
        //self.disconnect()
        //SocketService.disconnect()
    }
    
    /**
     Disconnects the robot from the video call room
     */
    private func disconnect() {
        guard self.client != nil else { return }
        
        if (self.remoteVideoTrack != nil) {
            self.remoteVideoTrack.removeRenderer(self.remoteView)
        }
        
        self.remoteVideoTrack = nil
        
        self.client.disconnect()
    }
    
    /**
     Handles the event when the client disconnects from the video call room
     */
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

