//
//  ViewExtensions.swift
//  Gandalf
//
//  Created by Sean Hart on 1/27/21.
//

import UIKit

class ProgressViewRoundedLeft: UIProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomLeft, .topLeft], radius: 0.0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

class ProgressViewRoundedRight: UIProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomRight, .topRight], radius: 0.0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
