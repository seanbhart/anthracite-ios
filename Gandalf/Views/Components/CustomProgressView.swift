//
//  CustomProgressView.swift
//  Gandalf
//
//  Created by Sean Hart on 1/27/21.
//

import Foundation
import UIKit

class CustomProgressView: UIView {
    var progress: CGFloat = 0.0 {

        didSet {
            setProgress()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    func setup() {
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        setProgress()
    }

    func setProgress() {
        var progress = self.progress
        progress = progress > 1.0 ? progress / 100 : progress

        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0

        let margin: CGFloat = 6.0
        var width = (self.frame.width - margin)  * progress
        let height = self.frame.height - margin

        if (width < height) {
            width = height
        }

        let pathRef = UIBezierPath(roundedRect: CGRect(x: margin / 2.0, y: margin / 2.0, width: width, height: height), cornerRadius: height / 2.0)

        UIColor.red.setFill()
        pathRef.fill()

        UIColor.clear.setStroke()
        pathRef.stroke()

        pathRef.close()

        self.setNeedsDisplay()
    }
}
