# MyRoIOS

MyRo iOS application that handles both client and robot side of the product. 

#### Client Side

Features:
  - User registration
  - User login
  - WebRTC communication with the robot 
  - Websocket channel with the robot

#### Robot Side

Features: 
  - WebRTC communication with client
  - Bluetooth communication with arduino attached to the wheels of the robot
  - Websocket channel with the client to receive movement instructions

#### How To Run

Requirements:
  - You must have the 'gem' unix command installed.
  - You must have the latest Xcode application installed (Swift 2.2), which requires you to have a mac.

1. Change directory into this iOS project root directory
2. Run 'pod install'
3. Open MyRo.xcworkspace in Xcode (only use MyRo.xcworkspace and never use MyRo.xcodeproj)
4. Select the appropriate iOS simulator or device to install the application on, in the top bar
4. Press the run button in the top left corner
