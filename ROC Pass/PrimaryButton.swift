//
//  PrimaryButton.swift
//  ROC Pass
//
//  Created by Dennis Beatty on 9/10/17.
//  Copyright © 2017 dennisbeatty. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = frame.size.height / 2
    }
}
