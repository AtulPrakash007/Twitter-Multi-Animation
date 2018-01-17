//
//  SplashAnimation.swift
//  TwitterMultipleAnimation
//
//  Created by Mac on 1/11/18.
//  Copyright © 2018 AtulPrakash. All rights reserved.
//

import Foundation
import UIKit

public typealias AnimationCompletion = () -> Void
public typealias AnimationExecution = () -> Void

// MARK: - SplashView Class extension to start the animation
extension SplashView {
    
    //---------------------------------
    //--- The function called to start the animation, Entry point of extention.
    //---------------------------------
    public func startAnimation(_ completion: AnimationCompletion? = nil)
    {
        DispatchQueue.main.async() { () -> Void in
            self.delegate.didBeginAnimatingWithDuration!(duration: self.duration)
        }
        
        switch animationType{
        case .twitter:
            playTwitterAnimation(completion)
            
        case .heartBeat:
            playHeartBeatAnimation(completion)
            
        case .ping:
            playPingAnimation(completion)
            
        case .blink:
            playBlinkAnimation(completion)
            
        case .wooble:
            playWoobleAnimation(completion)
            
        case .swing:
            playSwingAnimation(completion)
            
        case .rotateOut:
            playRotateOutAnimation(completion)
        }
    }
    
    //---------------------------------
    //--- Makes the twitter animation overlay. For Squeeze change Shrink - 0.5 & Zoom in - 0.30
    //---------------------------------
    public func playTwitterAnimation(_ completion: AnimationCompletion? = nil)
    {
        if let imageView = self.imageView {
            
            //Define the shink and grow duration based on the duration parameter
            let shrinkDuration: TimeInterval = duration * 0.3
            
            //Plays the shrink animation
            UIView.animate(withDuration: shrinkDuration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
                //Shrinks the image
                imageView.transform = self.getZoomInTranform()
                
                //When animation completes, grow the image
            }, completion: { finished in
                
                self.playZoomOutAnimation(completion)
            })
        }
    }
    
    //---------------------------------
    //--- Makes the heartbeat animation of icon.
    //---------------------------------
    public func playHeartBeatAnimation(_ completion: AnimationCompletion? = nil)
    {
        if let imageView = self.imageView {
            
            let popForce = 1.5 // How much high can go.
            
            animateLayer({
                let animation = CAKeyframeAnimation(keyPath: "transform.scale")
                animation.values = [0, 0.1 * popForce, 0.015 * popForce, 0.2 * popForce, 0]
                animation.keyTimes = [0, 0.25, 0.50, 0.75, 1]
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                animation.duration = CFTimeInterval(self.duration/2)
                animation.isAdditive = true
                animation.repeatCount = Float(minimumBeats > 0 ? minimumBeats : 1)
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(self.delay/2)
                imageView.layer.add(animation, forKey: "pop")
            }, completion: { [weak self] in
                if self?.continousAnimation ?? true {
                    self?.playHeartBeatAnimation(completion)
                } else {
                    self?.playZoomOutAnimation(completion)
                }
            })
        }
    }
    
    //---------------------------------
    //--- Makes the ping animation of icon.
    //---------------------------------
    public func playPingAnimation(_ completion:AnimationCompletion? = nil)
    {
        if let imageView = self.imageView {
            animateLayer({
                let animation = CAKeyframeAnimation(keyPath: "transform.scale")
                animation.values = [-0.3, -0.2, -0.1, 0]
                animation.keyTimes = [0.25, 0.5, 0.75, 1]
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                animation.duration = CFTimeInterval(self.duration/2)
                animation.isAdditive = true
                animation.repeatCount = Float(minimumBeats > 0 ? minimumBeats : 1)
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(self.delay/2)
                imageView.layer.add(animation, forKey: "pulse")
            }, completion: { [weak self] in
                if self?.continousAnimation ?? true {
                    self?.playPingAnimation(completion)
                } else {
                    self?.playZoomOutAnimation(completion)
                }
            })
        }
    }
    
    //---------------------------------
    //--- Makes the Blink animation of icon.
    //---------------------------------
    public func playBlinkAnimation(_ completion:AnimationCompletion? = nil)
    {
        if let imageView = self.imageView {
            animateLayer({
                let animation = CAKeyframeAnimation(keyPath: "opacity")
                animation.values = [1.0, 0.0, 1.0]
                animation.keyTimes = [0, 0.5, 1]
                animation.duration = CFTimeInterval(self.duration/2)
                animation.calculationMode = kCAAnimationDiscrete
                animation.repeatCount = Float(minimumBeats > 0 ? minimumBeats : 1)
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(self.delay/2)
                imageView.layer.add(animation, forKey: "opacity")
            }, completion: { [weak self] in
                if self?.continousAnimation ?? true {
                    self?.playBlinkAnimation(completion)
                } else {
                    self?.playZoomOutAnimation(completion)
                }
            })
        }
    }
    
    //---------------------------------
    //--- Makes the wooble animation of icon in x direction.
    //--- (if required set as position.y for y direction)
    //---------------------------------
    public func playWoobleAnimation(_ completion: AnimationCompletion? = nil) {
        
        if let imageView = self.imageView{
            
            let woobleForce = 0.5
            
            animateLayer({
                let rotation = CAKeyframeAnimation(keyPath: "transform.rotation")
                rotation.values = [0, 0.3 * woobleForce, -0.3 * woobleForce, 0.3 * woobleForce, 0]
                rotation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                rotation.isAdditive = true
                
                let positionX = CAKeyframeAnimation(keyPath: "position.x")
                positionX.values = [0, 30 * woobleForce, -30 * woobleForce, 30 * woobleForce, 0]
                positionX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                positionX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                positionX.isAdditive = true
                
                let animationGroup = CAAnimationGroup()
                animationGroup.animations = [rotation, positionX]
                animationGroup.duration = CFTimeInterval(self.duration/2)
                animationGroup.beginTime = CACurrentMediaTime() + CFTimeInterval(self.delay/2)
                animationGroup.repeatCount = 2
                imageView.layer.add(animationGroup, forKey: "wobble")
            }, completion: {
                
                self.playZoomOutAnimation(completion)
            })
            
        }
    }
    
    //---------------------------------
    //--- Makes the Swing animation of icon in x direction.
    //---------------------------------
    public func playSwingAnimation(_ completion: AnimationCompletion? = nil)
    {
        if let imageView = self.imageView{
            
            let swingForce = 0.8
            
            animateLayer({
                
                let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
                animation.values = [0, 0.3 * swingForce, -0.3 * swingForce, 0.3 * swingForce, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.duration = CFTimeInterval(self.duration/2)
                animation.isAdditive = true
                animation.repeatCount = 2
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(self.delay/3)
                imageView.layer.add(animation, forKey: "swing")
                
            }, completion: {
                self.playZoomOutAnimation(completion)
            })
        }
    }
    
    //---------------------------------
    //--- Makes the Rotate animation.
    //---------------------------------
    public func playRotateOutAnimation(_ completion: AnimationCompletion? = nil)
    {
        if let imageView = self.imageView{
            
            /**
             Sets the animation with duration delay and completion
             
             - returns:
             */
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: UIViewAnimationOptions(), animations: {
                
                //Sets a simple rotate
                let rotateTranform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.99))
                //Mix the rotation with the zoom out animation
                imageView.transform = rotateTranform.concatenating(self.getZoomOutTranform())
                //Removes the animation
                self.alpha = 0
                
            }, completion: { finished in
                
                self.removeFromSuperview()
                
                completion?()
            })
            
        }
    }
    
    
    //MARK: Supporting Methods
    
    
    //---------------------------------
    //--- Twitter Zoom out animation performs here.
    //--- Remove the view after animation
    //---------------------------------
    public func playZoomOutAnimation(_ completion: AnimationCompletion? = nil)
    {
        if let imageView =  imageView
        {
            let growDuration: TimeInterval =  duration * 0.3
            
            UIView.animate(withDuration: growDuration, animations:{
                
                imageView.transform = self.getZoomOutTranform()
                self.alpha = 0
                
                //When animation completes remote self from super view
            }, completion: { finished in
                DispatchQueue.main.async() { () -> Void in
                    self.delegate.didEndAnimating!()
                }
                self.removeFromSuperview()
                
                completion?()
            })
        }
    }
    
    //---------------------------------
    //--- stop the heart beat, ping & Bounce - whichever running
    //--- Once the heart beat stops the Zoom out function called to perform the final animation
    //---------------------------------
    public func stopIndefiniteAnimation()
    {
        self.continousAnimation = false
    }
    
    //---------------------------------
    //--- returns the default zoom out transform
    //---------------------------------
    fileprivate func getZoomInTranform() -> CGAffineTransform
    {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        return zoomOutTranform
    }
    
    //---------------------------------
    //--- returns the default zoom out transform
    //---------------------------------
    fileprivate func getZoomOutTranform() -> CGAffineTransform
    {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 20, y: 20)
        return zoomOutTranform
    }
    
    //---------------------------------
    //--- Animate layer continuosly to show as heart beat
    //---------------------------------
    fileprivate func animateLayer(_ animation: AnimationExecution, completion: AnimationCompletion? = nil) {
        
        CATransaction.begin()
        if let completion = completion {
            CATransaction.setCompletionBlock { completion() }
        }
        animation()
        CATransaction.commit()
    }
}

// MARK: Api call start animation

extension SplashView{
    public func startAnimation(url:String, method: String, params: [String: String], completion: @escaping (NSDictionary)->() ){
        
        self.startAnimation()
        
        if let nsURL = URL(string:url) {
            let request = NSMutableURLRequest(url: nsURL as URL)
            let postString:String?
            if method == "POST" {
                // convert key, value pairs into param string
                postString = params.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
                request.httpMethod = "POST"
                request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                request.httpBody = postString?.data(using: String.Encoding.utf8)
                //                request.setValue("text/json; oe=utf-8", forHTTPHeaderField: "Accept")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                do {
                    // what happens if error is not nil?
                    // That means something went wrong.
                    // Make sure there really is some data
                    if let data = data {
                        let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        print(datastring ?? "default value")
                        //                        var jsonResultDic:NSDictionary  = [String:AnyObject]() as NSDictionary
                        let jsonResultDic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        completion(jsonResultDic)
                    }
                    else {
                        print("Data is nil")
                    }
                } catch let error as NSError {
                    print("json error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
        else{
            // Could not make url. Is the url bad?
            // You could call the completion handler (callback) here with some value indicating an error
        }
    }
}
