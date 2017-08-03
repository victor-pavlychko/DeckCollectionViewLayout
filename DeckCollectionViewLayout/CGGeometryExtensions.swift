//
//  CGGeometryExtensions.swift
//  NoteBucket
//
//  Created by Victor Pavlychko on 7/29/17.
//  Copyright © 2017 address.wtf. All rights reserved.
//

import CoreGraphics

internal extension CGFloat {
    
    internal var signum: CGFloat {
        if self > 0 {
            return 1
        } else if self < 0 {
            return -1
        } else {
            return 0
        }
    }
    
    internal func scaleFactor(to value: CGFloat) -> CGFloat {
        return self != 0 ? value / self : 0
    }
    
    internal func scaleFactor(delta: CGFloat) -> CGFloat {
        return scaleFactor(to: self + delta)
    }
}

internal extension CGPoint {
    
    internal var length: CGFloat {
        return sqrt(x * x + y * y)
    }
    
    internal static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}

internal extension CGRect {
    
    internal var mid: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

internal extension CGAffineTransform {
    
    internal func translated(by value: CGPoint) -> CGAffineTransform {
        return translatedBy(x: value.x, y: value.y)
    }
    
    internal func scaled(by value: CGFloat) -> CGAffineTransform {
        return scaledBy(x: value, y: value)
    }
}
