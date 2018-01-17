//
//  AnimationType.swift
//  TwitterMultipleAnimation
//
//  Created by Mac on 1/11/18.
//  Copyright © 2018 AtulPrakash. All rights reserved.
//

import Foundation

//---------------------------------
//--- Twitter: The default animation type is the Twitter App animation
//--- If required to call the API, call the heartbeat animation
//---------------------------------
public enum AnimationType: String{
    case twitter //Squeeze
    case heartBeat
    case ping //Pulse Effect
    case blink //Opacity
    case wooble
    case swing
    case rotateOut
    
    static let animationNames = [twitter, heartBeat, ping, blink, wooble, swing, rotateOut]
}
