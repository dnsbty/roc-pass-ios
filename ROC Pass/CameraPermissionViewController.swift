//
//  CameraPermissionViewController.swift
//  ROC Pass
//
//  Created by Dennis Beatty on 9/11/17.
//  Copyright © 2017 dennisbeatty. All rights reserved.
//

import UIKit

class CameraPermissionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enable(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
}
