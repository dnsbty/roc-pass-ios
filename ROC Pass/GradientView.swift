//
//  GradientView.swift
//  ROC Pass
//
//  Created by Dennis Beatty on 8/9/17.
//  Copyright © 2017 dennisbeatty. All rights reserved.
//

import UIKit

@IBDesignable public class GradientView: UIView {
    @IBInspectable public var topColor: UIColor = UIColor.clear {
        didSet {
            configureView()
        }
    }
    @IBInspectable public var bottomColor: UIColor = UIColor.clear {
        didSet {
            configureView()
        }
    }
    
    public func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        configureView()
    }
    
    func configureView() {
        let layer = CAGradientLayer()
        layer.frame = self.frame
        let locations = [ 0.0, 1.0 ]
        layer.locations = locations as [NSNumber]
        let color1 = topColor
        let color2 = bottomColor
        let colors: Array <AnyObject> = [ color1.cgColor, color2.cgColor ]
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.insertSublayer(layer, at: 0)
    }
}
