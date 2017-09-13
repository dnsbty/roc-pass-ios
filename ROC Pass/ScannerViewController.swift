//
//  ScannerViewController.swift
//  ROC Pass
//
//  Created by Dennis Beatty on 9/10/17.
//  Copyright © 2017 dennisbeatty. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController : UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var parentVC : ViewController?
    var error : NSError? = nil
    
    @IBOutlet weak var scanOverlay: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure the app has permission to access the device's camera
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        print("Status: \(authorizationStatus)")
        
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                if !granted {
                    self.performSegue(withIdentifier: "enableCamera", sender: self)
                    return
                }
            }
            break
        case .authorized: break
        case .denied, .restricted:
            self.performSegue(withIdentifier: "enableCamera", sender: self)
            return
        }
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input device on the captureSession
            captureSession?.addInput(input as AVCaptureInput)
        }
        catch let error as NSError {
            // If any error occurs, store it for popup display and don't continue any further
            self.error = error
            return
        }
        
        // Initialize an AVCaptureMetadataOutput object and set it as the output device to the capture session
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the callback
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeCode39Code]
        
        // Initialize the video preview layer and add it as a sublayer to the view preview view's layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture
        captureSession?.startRunning()
        
        // Bring UI to the front
        view.bringSubview(toFront: scanOverlay)
        view.bringSubview(toFront: cancelButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if there was an error while loading the view
        if error != nil {
            
            // otherwise just use a basic popup
            let alert = UIAlertController(title: error?.localizedDescription, message: error?.localizedRecoverySuggestion, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                self.cancel(self)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object
        if metadataObjects == nil || metadataObjects.count == 0 {
            return
        }
        
        // Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeCode39Code {
            captureSession?.stopRunning()
            
            if metadataObj.stringValue != nil {
                UserDefaults.standard.set(metadataObj.stringValue, forKey: "code")
                // TODO: tell the parent VC that a code is now present
                // self.parentVC?.reloadCode()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
