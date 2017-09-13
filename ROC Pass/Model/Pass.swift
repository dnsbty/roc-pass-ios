//
//  Pass.swift
//  ROC Pass
//
//  Created by Dennis Beatty on 9/12/17.
//  Copyright © 2017 dennisbeatty. All rights reserved.
//

import Foundation
import RealmSwift

class Pass: Object {
    dynamic var code = ""
    dynamic var createdAt = Date(timeIntervalSince1970: 1)
}
