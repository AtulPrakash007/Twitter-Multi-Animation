//
//  ViewController.swift
//  TwitterMultipleAnimation
//
//  Created by Mac on 1/11/18.
//  Copyright © 2018 AtulPrakash. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTwitterSplash(animation: AnimationType.animationNames[0].rawValue)
        tblView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //---------------------------------
    //--- In case of API Call
    //--- Either call the method definition inside the Api Call,
    //--- and after completion process the heartattack variable as false
    //--- OR
    //--- Define the splash view global for this view controller and add subview in API call
    //--- and after completion process the heartattack variable as false
    //---------------------------------
    func loadTwitterSplash(animation name:String) -> Void {
        let splashView = SplashView(iconImage: UIImage(named: "lantern")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red: 70/255, green: 154/255, blue: 233/255, alpha: 1))
        
        self.view.addSubview(splashView)
        
        // Blink - 1.0 ; Heartbeat - 3.0
        splashView.duration = 1.0
        splashView.animationType = AnimationType(rawValue: name)!
        splashView.iconColor = UIColor.red
        splashView.useCustomIconColor = false
        splashView.delegate = self
        
        splashView.startAnimation(){
            print("Completed")
        }
        
        // This will deliver the message to stop the heartbeat
        // Need to call like same after the completion of API, means when screen transition needs.
        // Comment and run this, you will see heartbeat will never stops.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            print("Animation Stopped")
            splashView.stopIndefiniteAnimation()
        })
    }
    
    // Get the required result from API
    // Modify the method as required like get (data, response, error) in place of dictionary.
    
    func loadTwitterSplashWithAPI(animation name:String) -> Void {
        let splashView = SplashView(iconImage: UIImage(named: "lantern")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red: 70/255, green: 154/255, blue: 233/255, alpha: 1))
        
        self.view.addSubview(splashView)
        
        // Blink - 1.0 ; Heartbeat - 3.0
        splashView.duration = 1.0
        splashView.animationType = AnimationType(rawValue: name)!
        splashView.iconColor = UIColor.red
        splashView.useCustomIconColor = false
        splashView.delegate = self
        
        splashView.startAnimation(url: "", method: "", params: [:], completion: {(result) in
            print(result)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                print("Animation Stopped")
                splashView.stopIndefiniteAnimation()
            })
        })
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}

// MARK: UITableViewDataSource

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnimationType.animationNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let name = AnimationType.animationNames[indexPath.row]
        cell.textLabel?.text = String(describing: name)
        return cell
    }
}

// MARK: UITableViewDelegate

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
        print(currentCell?.textLabel?.text ?? "Cell Value Not Fetched")
        loadTwitterSplash(animation: AnimationType.animationNames[indexPath.row].rawValue)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
        print(currentCell?.textLabel?.text ?? "Cell Value Not Fetched")
        loadTwitterSplash(animation: AnimationType.animationNames[indexPath.row].rawValue)
    }
}

// MARK: SplashViewProtocol

extension ViewController:SplashViewProtocol{
    
}
