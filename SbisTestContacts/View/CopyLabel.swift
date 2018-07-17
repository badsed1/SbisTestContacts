//
//  CopyLabel.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 15.07.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit

class CopyLabel: UILabel {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func copy(sender: AnyObject?) {
        UIPasteboard.general.string = text
    }
}
