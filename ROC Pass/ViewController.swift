//
//  ViewController.swift
//  ROC Pass
//
//  Created by Dennis Beatty on 7/31/17.
//  Copyright © 2017 dennisbeatty. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == AVAuthorizationStatus.denied || status == AVAuthorizationStatus.restricted {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "enableCamera", sender: self)
            }
        }
        printRealm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanPass(_ sender: Any) {
        self.performSegue(withIdentifier: "scanPass", sender: self)
    }

    @IBAction func scanLater(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "scanPass") {
            let newVC = segue.destination as! ScannerViewController
            newVC.parentVC = self
        }
    }
    
    func printRealm() {
        let realm = try! Realm()
        let passes = realm.objects(Pass.self)
        print("Passes: \(passes)")
    }
}

