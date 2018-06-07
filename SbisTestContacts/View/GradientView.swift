//
//  GradientView.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 04.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    var starColor: UIColor = .white
    var middleColor: UIColor = .white
    var endColor: UIColor = .red
    
    
    override func draw(_ rect: CGRect) {
        let contextRef = UIGraphicsGetCurrentContext()
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let location: [CGFloat] = [0.0, 0.9, 1.0]
        let colors: [CGColor] = [starColor.cgColor, middleColor.cgColor, endColor.cgColor]
        let gradient = CGGradient(colorsSpace: colorSpaceRef, colors: colors as CFArray, locations: location)
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        contextRef?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
    }
}
